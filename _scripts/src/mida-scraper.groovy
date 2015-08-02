#!/usr/bin/env groovy

@Grapes( @Grab('org.ccil.cowan.tagsoup:tagsoup:1.2') )

import org.ccil.cowan.tagsoup.Parser;

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

new URL(url).withReader (ENCODING) { reader ->
    def document = parser.parse(reader)
//    Extracting information
}

