require 'open-uri'
require 'pry'

class Scraper
  

  def self.scrape_index_page(index_url)
    students = Nokogiri::HTML(open(index_url))
    students_array = []
    students.css("div.student-card").each do |student|
      student_name = student.css("h4.student-name").text
      student_location = student.css("p.student-location").text
      student_url = student.css("a").attribute("href").value
      students_array << {name: student_name, location: student_location, profile_url: student_url}
    end
    students_array
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    student_page = Nokogiri::HTML(open(profile_url))
    links = student_page.css(".social-icon-container").children.css("a").map {|social_link| social_link.attribute('href').value}
    links.each do |link|
      if link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      else
        student[:blog] = link
      end
    end
    student[:bio] = student_page.css(".details-container .bio-block .description-holder p").text if student_page.css(".details-container .bio-block .description-holder p")
    student[:profile_quote] = student_page.css(".profile-quote").text if student_page.css(".profile-quote")
    student
  end
  
end