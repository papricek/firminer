require "fastercsv"

class CrawledRecord

  attr_accessor :name, :www, :address, :email, :phone, :url


  def initialize(page)
    doc = page.doc
    @name = CrawledRecord.get_from_css(doc, '#firmCont h2')
	@email = CrawledRecord.get_from_css(doc, '#cont .contactBlock .email a')
    @address = "#{CrawledRecord.get_from_css(doc, '.info .adr .street-address')} #{CrawledRecord.get_from_css(doc, '.info .adr .postal-code')} #{CrawledRecord.get_from_css(doc, '.info .adr .locality')}"
	@phone = CrawledRecord.get_from_css(doc, '#cont .tel .value')
    @description = CrawledRecord.get_from_css(doc, '#firmCont .description')
    @www = CrawledRecord.get_from_css(doc, '#firmCont .web a')
    @url = page.url.to_s
  end

  def self.get_from_css(doc, css)
      begin
        doc.css(css).text.strip.tr(";", "")
      rescue
        ""
      end
  end

  def to_csv
    [@name, @email, @address, @description, @www, @url, @phone].to_csv(:col_sep => ";")
  end
end
