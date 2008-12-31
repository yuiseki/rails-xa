require 'net/http'  
require 'cgi'  
require 'rexml/document'  
  
class Geocoder  
      
    ENDPOINT_URL = "http://maps.google.com/maps/geo?"  
      
    def initialize(key, format)  
        @key = key  
        @format = format  
    end  
      
    def getPoint(address)  
        xml = getResult(address)  
          
        point = nil  
        if xml.elements["/kml/Response/Status/code"].text == "200"  
            point = xml.elements["/kml/Response/Placemark/Point/coordinates"].text.split(/,/)  
        end  
          
        return point  
    end  
      
    def getResult(address)  
        url = createURL(address)  
        xml = REXML::Document.new( Net::HTTP.get( url ) )  
        return xml  
    end  
      
    private  
    def createURL(address)  
      
        parameters = {  
            :key => @key,  
          :q => address,  
          :output => @format  
        }  
          
        paramString = (  
            parameters.collect { |key,value| "#{key}=#{CGI::escape(value)}" }  
        ).join('&')  
          
        url = URI.parse( ENDPOINT_URL + paramString )  
        return url  
          
    end  
      
end  


