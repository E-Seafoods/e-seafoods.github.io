#!/usr/bin/env groovy

@Grapes( @Grab('com.xlson.groovycsv:groovycsv:1.0') )
import com.xlson.groovycsv.*
import java.text.Normalizer;
import java.text.Normalizer.Form;
import java.util.regex.Pattern;

def cli = new CliBuilder(usage: 'mida-scraper [csvFilePath]')
def options = cli.parse(args)
String csvFilePath
if (options.arguments()) {
    csvFilePath = options.arguments()[0]
}else{
    cli.usage()
    return
}

println "Scraping ${csvFilePath}..."

Pattern NONLATIN = Pattern.compile("[^\\w-]")
Pattern WHITESPACE = Pattern.compile("[\\s]")

File csvFile = new File(csvFilePath)
def csv = csvFile.text
def data = new CsvParser().parse(csv, autoDetect: true)
def productMap = [:]

data.findAll().groupBy { it.PRODUCT }.each { product ->
    String nowhitespace = WHITESPACE.matcher(product.value[0].PRODUCT.replaceAll(" - ", " ")).replaceAll("-")
    String normalized = Normalizer.normalize(nowhitespace, Form.NFD)
    String slug = NONLATIN.matcher(normalized).replaceAll("")

    productMap.layout = "product"
    productMap.slug = slug.toLowerCase(Locale.ENGLISH)
    productMap.name = product.value[0].PRODUCT
    productMap.categories = product.value[0].CATEGORY.toString().split(":")
    productMap.form = ""
    productMap.images = ["http://www.midafood.com/Data/Images/Cephalopods_album/1024x1024/54acdb77e60ec196.jpg"]
    productMap.description = product.value[0].DESCRIPTION
    productMap.measure = product.value[0].MEASURING_UNIT
    productMap.types = []

    product.value.findAll().groupBy {it.PRODUCT}.each { item ->
        item.value.findAll().groupBy {it.TYPE}.each { types ->
            List sizeList = new ArrayList();

            types.value.each { type ->
                def map = [
                        sku: type.SKU_ID,
                        size: type.SIZE,
                        price: type.PRICE_PER_UNIT
                ]
                sizeList.add(map)
            }
            productMap.types.add ([name: types.key, sizes: sizeList])
        }
    }

    'mkdir -p out'.execute()
    File file = new File('out/' + productMap.slug +'.md')
    file.write ('---')
    file << '\n'
    file << "layout: \"$productMap.layout\"\n"
    file << "slug: \"$productMap.slug\"\n"
    file << "name: \"$productMap.name\"\n"
    file << "categories:\n"
    productMap.categories.each { category ->
        file << "   - \"$category\"\n"
    }
    file << "images:\n"
    productMap.images.each { image ->
        file << "   - \"$image\"\n"
    }
    file << "description: >\n"
    file << "   $productMap.description\n"
    file << "measure: \"$productMap.measure\"\n"
    file << "types: \n"
    productMap.types.each { types ->
        file << "   - name: \"$types.name\"\n"
        file << "     sizes: \n"
        types.sizes.each{ size ->
            file << "     - sku: $size.sku\n"
            file << "       size: \"$size.size\"\n"
            file << "       price: $size.price\n"
        }
    }

    file << '---' << '\n'
}

println "Finish parsing $csvFilePath"