require 'open-uri'
require 'nokogiri'
require 'pry'



class Scraper
  

  def self.scrape_index_page(index_url)
  index_url = Nokogiri::HTML(open(index_url)) 
    students = []
  index_url.css(".roster-cards-container").each do |card| 
    card.css(".student-card a").each do |student|
     student_name = student.css(".student-name").text
     student_location = student.css(".student-location").text
     student_url = "#{student.attr("href")}"
     students << {name:student_name, location:student_location, profile_url:student_url}
    end
  end
  students
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
  individual_profile = {}
  links = profile.css(".social-icon-container").children.css("a")
  
  links.each do |link|
    if link.attr("href").include?("twitter") 
     
      individual_profile[:twitter] = link.attr("href")
    elsif link.attr("href").include?("linkedin") 
      individual_profile[:linkedin] = link.attr("href")
    elsif link.attr("href").include?("github") 
      individual_profile[:github] = link.attr("href")
    else 
      individual_profile[:blog] = link.attr("href")
   

    end
  end
individual_profile[:profile_quote] = profile.css(".vitals-text-container").css(".profile-quote").text if profile.css(".vitals-text-container").css(".profile-quote")
  individual_profile[:bio] = profile.css(".bio-content.content-holder").css(".description-holder p").text if profile.css(".bio-content.content-holder").css(".description-holder p")


  individual_profile

  end

end

