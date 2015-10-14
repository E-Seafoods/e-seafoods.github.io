import com.opencsv.bean.BeanToCsv
import com.opencsv.CSVWriter
import com.opencsv.bean.ColumnPositionMappingStrategy
import com.opencsv.bean.MappingStrategy
import com.opencsv.bean.CsvToBean
import groovy.json.JsonSlurper

String csvFilePath = 'kmart.csv'
File csvFile = new File(csvFilePath)
//def data = new CsvParser().parse(new FileReader(csvFile))
//
//List products
//List productList = []
//
//data.each { row ->
//    Map product = [:]
//    row.columns.each{ key, value ->
//        product[key] = row[key]
//    }
//    new product(product)
//}


ColumnPositionMappingStrategy strat = new ColumnPositionMappingStrategy()
strat.setType(product.class)
String[] columns = ["id", "upc", "asin", "link", "price", "quantity", "nomatch"] // the fields to bind do in your JavaBean
strat.setColumnMapping(columns)

CsvToBean csv = new CsvToBean()
List list = csv.parse(strat, new FileReader(csvFile))

CSVWriter writer = new CSVWriter(new FileWriter("out.csv"))
BeanToCsv bean = new BeanToCsv()
MappingStrategy strat2 = strat
bean.write(strat2, writer, list)


println 'aw'






String ENCODING = "UTF-8"
String url = "http://www.kmart.com/kids-dora-bucket/p-043W005402769001P?prdNo=2"
String productID = url.find("p-(.*)\\?") { full, matched -> return matched }
String JSONURL = "http://www.kmart.com/content/pdp/config/products/v1/products/$productID?site=kmart"

println "Scraping ${JSONURL}..."

def parser = new JsonSlurper()

CookieHandler.setDefault(new CookieManager(null, CookiePolicy.ACCEPT_ALL))
URLConnection connection = new URL(JSONURL).openConnection()
connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.95 Safari/537.11")
connection.connect()

String cookie = connection.getHeaderField( "Set-Cookie").split(";")[0];
connection = new URL(JSONURL).openConnection();
connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.95 Safari/537.11");
connection.setRequestProperty("Cookie", cookie );
connection.connect();


String pageContent = connection.with { con ->
    // We'll do redirects ourselves
    con.instanceFollowRedirects = false

    // Get the location to jump to (in case of a redirect)
    location = con.getHeaderField( "Location" )

    // Read the HTML and close the inputstream
    con.inputStream.withReader { reader1 ->
        def document = parser.parse(reader1)

        String UPC = document.data.offer.altIds.upc
    }
}

class product {
    String id
    String upc
    String asin
    String link
    String price
    String quantity
    String nomatch

    public void setData(final Map data){
        this.data = data;
    }
}