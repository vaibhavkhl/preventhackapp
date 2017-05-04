class PreventHackController < ApplicationController
  require "net/http"
  def new
  end

  def create
    file_data = params[:file].tempfile
    file = IO.readlines(file_data)
    log_array = file.reject {|i| i == "\n" }
    new_array = []
    log_array.each do |log|
      l=log.gsub('"', '')
      v = l.split(' ')
      new_array.push(v)
    end
    @log_obj_array = check_for_hack(new_array)
  end
end

private

def check_for_hack(new_array)
  log_obj_array = []
  new_array.each do |log|
    if log.count == 18
      origin_header = log[3] + ' ' + log[4]
      client_ip = log[9]
    else
      origin_header = log[3]
      client_ip = log[8]
    end
    log_obj = {}
    log_obj['is_hack'] = is_hack(origin_header, client_ip)
    log_obj['log'] = log
    log_obj_array.push(log_obj)
  end
  log_obj_array
end

def is_hack(origin_header, client_ip)
  return 'yes' if (origin_header == "MATLAB R2013a" || is_ip_from_outside_india(client_ip))
  'no'
end

def is_ip_from_outside_india(client_ip)
  ip = client_ip.slice(0..(client_ip.index(':')))
  ip = ip.chomp(':')
  uri = "http://ip-api.com/json/" + ip
  ipinfo = Net::HTTP.get(URI(uri))
  country = eval(ipinfo)[:country]
  return true if country != "India"
  false
end
