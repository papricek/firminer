require "rubygems"
require "anemone"
require "fastercsv"
require "lib/crawled_record"

puts "Firminer - data miner from directory Firmy.cz"


categories = FasterCSV.read("data/categories.csv")

puts "-- read categories file -- "


categories.each do |row|
  category_url = row[1].strip
  category_ascii_name = category_url[/[^\/]+?$/]
  file_name = "#{category_ascii_name}.csv"

  begin
    puts "-- crawling #{category_ascii_name} -- "
    puts category_url
    Anemone.crawl(category_url) do |anemone|
      anemone.focus_crawl do |page|
        unless page.url.to_s.include?("/detail/")
          page.links.select { |link| link.to_s.include?(category_url) or link.to_s.include?("/detail/") }.reject { |link| link.to_s.include?("/reg/") }
        else
          []
        end
      end

      file = File.new("data/#{file_name}", "w")
      anemone.on_pages_like(/\/detail\//) do |page|
        file.puts CrawledRecord.new(page).to_csv
      end


      anemone.after_crawl do |pages|
        puts "-- Crawled #{0} companies \n"
      end
    end

  rescue
    puts "-- #{category_ascii_name} failed to get crawled --"
  end
end
