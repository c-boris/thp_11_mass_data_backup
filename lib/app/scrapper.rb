require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'
require 'google_drive'

class MairieScraper
  def initialize(url)
    @url = url
    @mairies = []
  end

  def scrape
    page = Nokogiri::HTML(URI.open(@url))
    page.css('.lientxt').each do |link|
      mairie_url = "http://annuaire-des-mairies.com#{link['href'][1..-1]}"
      mairie_name = link.text.capitalize
      mairie_email = get_mairie_email(mairie_url)
      @mairies << { name: mairie_name, email: mairie_email }
    end
  end

  def save_as_json(file_name)
    File.open(file_name, 'w') do |f|
      f.write(JSON.pretty_generate(@mairies))
    end
  end

  def save_as_csv(file_name)
    CSV.open(file_name, 'wb') do |csv|
      csv << ['Name', 'Email']
      @mairies.each do |mairie|
        csv << [mairie[:name], mairie[:email]]
      end
    end
  end

  def save_as_spreadsheet(file_name)
    session = GoogleDrive::Session.from_config('config.json')
    ws = session.create_spreadsheet(file_name).worksheets[0]
    ws[1, 1] = 'Name'
    ws[1, 2] = 'Email'
    row = 2
    @mairies.each do |mairie|
      ws[row, 1] = mairie[:name]
      ws[row, 2] = mairie[:email]
      row += 1
    end
    ws.save
  end

  private

  def get_mairie_email(mairie_url)
    page = Nokogiri::HTML(URI.open(mairie_url))
    td_with_email = page.css('td:contains("@")').first
    td_with_email ? td_with_email.text.strip : "email inconnu"
  end
end