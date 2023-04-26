require 'bundler'
Bundler.require

require_relative 'lib/app/scrapper'

# Menu
puts "Veuillez choisir le format de sortie des données :"
puts "1 - JSON"
puts "2 - CSV"
# puts "3 - Google Spreadsheet"
print "> "

format_choice = gets.chomp.to_i

scraper = MairieScraper.new("http://annuaire-des-mairies.com/val-d-oise.html")
scraper.scrape

case format_choice
when 1
  scraper.save_as_json("db/emails.json")
  puts "Les données ont été sauvegardées au format JSON dans le fichier db/emails.json"
when 2
  scraper.save_as_csv("db/emails.csv")
  puts "Les données ont été sauvegardées au format CSV dans le fichier db/emails.csv"
# when 3
#   scraper.save_as_spreadsheet("mairies")
#   puts "Les données ont été sauvegardées au format Google Spreadsheet"
else
  puts "Choix invalide"
end



