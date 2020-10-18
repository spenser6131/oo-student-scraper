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
    student_page = Nokogiri::HTML(open(profile_url))
    student = {}
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
    student[:bio] = student_page.css(".details-container .bio-block .description-holder p").text
    student[:profile_quote] = student_page.css(".profile-quote").text
    student
  end
  
end


# :twitter=>"http://twitter.com/flatironschool",
# :linkedin=>"https://www.linkedin.com/in/flatironschool",
# :github=>"https://github.com/learn-co",
# :blog=>"http://flatironschool.com",
# :profile_quote=>"\"Forget safety. Live where you fear to live. Destroy your reputation. Be notorious.\" - Rumi",
# :bio=> "I'm a school"