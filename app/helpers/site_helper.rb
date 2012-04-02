module SiteHelper
 def banner_echo user, width, heigth, file
    "<embed src=\"#{CFG["prot"]}/banners/#{file}.swf?subdomain=#{user}\" pluginspage=\"http://www.macromedia.com\" type=\"application/x-shockwave-flash\" height=\"#{width}\" width=\"#{heigth}\" wmode=\"transparent\">"
 end
end
