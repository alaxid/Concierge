class ServiceForwardController < ApplicationController

  def homepagerequest

    @servicename = params[:service].gsub("-", " ")
    puts "========="
    puts @servicename
    service = Service.where(:serviceName => @servicename)
    competence = service[0].competences.where(:competenceType => "Home")
    homeurl = service[0].url

    user = User.find(session[:user_id])
    if user.notAnonymus != nil
      @logged = "true"
    else @logged = "false"
    end

    @url = homeurl
    @doc = Nokogiri::XML(open(@url), nil, 'UTF-8')

    nodes = @doc.xpath("//link")

    root = @doc.root()
    root['logged'] = @logged

    address = get_address

    nodes.each do |node|
      href = node['href']
      link = href.gsub(homeurl, address+"services/"+@servicename.gsub(" ", "%"))
      node['href'] = link
    end
    search = service[0].competences.where(:competenceType => "Search")

    if search[0] != nil then
    search_link = search[0].competenceUrl.gsub(homeurl, address+"services/"+@servicename.gsub(" ", "%"))
    root = @doc.at_css "record"
    root.add_child("<search>"+search_link+"?keyword=")
    end
    respond_to :xml
  end

  def listrequest

    @servicename = params[:service]
    @method = params[:method]
    @start = (params[:start] || "1")
    @end = (params[:end] || "7")
    service = Service.where(:serviceName => @servicename)
    serviceurl = service[0].url

    user = User.find(session[:user_id])
    if user.notAnonymus != nil
      @logged = "true"
    else @logged = "false"
    end

    @url = serviceurl + "/" + @method + "?start="+@start+"&end="+@end
    puts @url
    @doc = Nokogiri::XML(open(@url), nil, 'UTF-8')

    root = @doc.at_css("list")
    root['logged'] = @logged

    address = get_address

    next_url = root['next']
    next_url = next_url.gsub(serviceurl, address + "services/"+@servicename.gsub(" ", "%"))
    root['next'] = next_url
    nodes = @doc.xpath("//item")



    nodes.each do |node|
      href = node['href']
      if href != nil
       link = href.gsub(serviceurl, address + "services/"+@servicename.gsub(" ", "%"))
       node['href'] = link
      end
    end

    respond_to :xml
  end


  def recordrequest

    @servicename = params[:service].gsub("%", " ")
    @id = params[:id]
    @method = params[:method]

    address = get_address
    @url = address+"services/"+@servicename+"/"+@method+"/"+@id

    service = Service.where(:serviceName => @servicename)
    serviceurl = service[0].url

    user = User.find(session[:user_id])
    if user.notAnonymus != nil
      @logged = "true"
    else @logged = "false"
    end
    querystring = ""
    params.each_pair do |key, value|
      if key.to_s != "format" && key.to_s != "controller" && key.to_s != "action" && key.to_s != "service" && key.to_s != "method" && key.to_s != "id" then
        querystring = querystring + "&" + key.to_s + "=" + value.to_s
      end
    end

    if querystring == ""
      link = serviceurl + "/" +@method+"/"+@id
    else
      link = serviceurl + "/" +@method+"/"+@id+"?"+querystring
    end

    @doc = Nokogiri::XML(open(link), nil, 'UTF-8')

    if @doc.at_css("record") then

    record = @doc.at_css("record")
    title = record['title']

    record['logged'] = @logged
    record['url'] = @url

    if session[:user_id] != nil then
      History.create :user_id => session[:user_id], :time => Time.now, :description => title, :url => get_address + "services/"+@servicename.gsub(" ", "%")+"/"+@method+"/"+@id
    end

    entity = @doc.xpath("//entity");
    entity.each do |node|

      parent = node.parent()
      kind = node.attr('kind')
      service = node.attr('service')
      serviceType = node.attr('serviceType')
      title = node.attr('title')
      value = node.text()

      node.remove
      plus_value = value.gsub(" ", "+")

      link = get_address

      if service != nil then
        link += 'services/'+service+'search?keyword='+plus_value
      elsif kind != nil then
        plus_kind = kind.gsub(" ", "+")
        link += 'search?keyword='+plus_value+'&amp;entity='+plus_kind
      else
        plus_serviceType = servie.gsub(" ", "+")
        link += 'search?keyword='+plus_value+'&amp;type='+plus_serviceType
      end

      if title == nil
        parent.add_child('<entity href="'+link+'">'+value+'</entity>')
      else
        parent.add_child('<entity title="'+title+'" href="'+link+'">'+value+'</entity>')
      end

    end

    link_tag = @doc.xpath("//link")

    address = get_address

    link_tag.each do |node|

      href = node['href']
      if href == nil then
        node.name = "external_link"
        href = node['ehref']
      end
      link = href.gsub(serviceurl, address+"services/"+@servicename.gsub(" ", "%"))
      node['href'] = link

    end

  elsif @doc.at_css("map")
  end

  respond_to :xml

  end
end
