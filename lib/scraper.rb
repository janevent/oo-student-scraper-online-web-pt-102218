require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    student_info = []
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    #binding.pry
    doc.css(".roster-cards-container").each do |card|
      #binding.pry
     card.css(".student-card a").each do |student|
      
        name = student.css(".student-name").text 
        location = student.css(".student-location").text
        profile = "#{student.attr('href')}"
        hash = {}
        # binding.pry
        hash[:name] = name
        #binding.pry
        hash[:location] = location
    
        hash[:profile_url] = profile
    
        student_info << hash
      end
    end
    student_info
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
   # binding.pry
    student_hash = {}
    doc.css(".social-icon-container").children.css('a').each do |link|
    #binding.pry
        if link.attr('href').include?("twitter")
          student_hash[:twitter] = link.attr('href')
        elsif link.attr('href').include?("linkedin")
          student_hash[:linkedin] = link.attr('href')
        elsif link.attr('href').include?("github")
          student_hash[:github] = link.attr('href')
        else
          student_hash[:blog] = link.attr('href')
        end
    end
      student_hash[:profile_quote] = doc.css(".profile-quote").text
      student_hash[:bio] = doc.css(".description-holder p").text
      student_hash
  end
end

