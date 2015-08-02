#!/usr/bin/env groovy

@Grapes( @Grab('org.ccil.cowan.tagsoup:tagsoup:1.2') )

import org.ccil.cowan.tagsoup.Parser

import java.math.RoundingMode;

String ENCODING = "UTF-8"

def cli = new CliBuilder(usage: 'mida-scraper [url]')

def options = cli.parse(args)

String url
if (options.arguments()) {
    url = options.arguments()[0]
}else{
    cli.usage()
    return
}

println "Scraping ${url}..."

def parser = new XmlSlurper(new Parser() )

Map data = [:]
data.slug = url.substring(url.lastIndexOf('/')+1)

String baseUrl = url.take(url.indexOf('/', url.indexOf('://')+3))

new URL(url).withReader (ENCODING) { reader ->
    def document = parser.parse(reader)
    def productDetails = document.'**'.find { it.@id == 'productDetails' }
    data.name = productDetails.h2.text()
    data.description = productDetails.div[0].div[1].text()

    def getProperty = { String property ->
        productDetails.'*'.find{ it.@class == 'row' && it.div[0].text().toLowerCase().contains(property.toLowerCase()) }.div[1].text()
    }

    ['specie', 'form'].each{ property ->
        data[property] = getProperty(property)
    }

    data.images = [baseUrl + document.'**'.find{ it.@id == 'imageContainer' }.img.@src]

}

'mkdir -p out'.execute()

File file = new File('out/'+data.slug+'.md')
file.write ('---')
file << '\n'
file << 'layout: demo' << '\n'
data.each{ key, value ->
    if (value instanceof String) {
        file << "$key: $value" << '\n'
    } else if (value instanceof List) {
        file << "$key:" << '\n'
        value.each{
            file << "    - ${it}" << '\n'
        }
    }
}

file << 'types:' << '\n'
file << '   - name: fresh' << '\n'
file << '     sizes:' << '\n'
file << '     -  size: normal' << '\n'

BigDecimal randomPrice = new Random().nextInt(6000)
file << '        price: '+randomPrice.setScale(2, RoundingMode.HALF_UP) << '\n'

file << '---' << '\n'
