class QuicksearchesController < ApplicationController

	def index

    if !params[:paginating].nil? then @paginating = params[:paginating] else @paginating = false end

		@quicksearch = Quicksearch.new

    @companies = []

    if params[:orientation].nil? and params[:semester].nil? and params[:programming_language_ids].nil? and params[:country].nil?
      @internships = Internship.order("created_at DESC") 
    else
      @internships = @quicksearch.internships(params)
    end

    @internships.each do |i|
      @companies << i.company
    end

		@pins = @companies.to_gmaps4rails do |company, marker |
      href =  if company.website.starts_with?'http' 
                company.website  
              else 
                "http://"+company.website 
              end
      marker.infowindow ("<a href='/companies/#{company.id}' style='font-weight:bold'>#{company.name}</a><p>Industry: #{company.industry}</p><p>Employees: #{company.number_employees}</p><a href='#{href}' target='_blank'>#{company.website}</a>")

    end

    @internships = @internships.page params[:page]

    respond_to do |format|
      format.js { render :layout=>false, :locals => { :pins  => @pins, :internships => @internships, :paginating => @paginating } }
    end
  end

end
