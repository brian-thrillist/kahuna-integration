#!/usr/bin/env ruby

module HashToCSV
  def self.is_bottom_value?(value)
    !(value.is_a?(Array) || value.is_a?(Hash))
  end

  def self.array_to_hash(array)
    new_hash = {}
    array.each_with_index do |el, index|
      new_hash[index] = el
    end
    new_hash
  end

  def self.flatten(hash, header_string="")
    new_hash = {}
    hash.each do |k,v|
      header = "#{header_string}#{k}"
      if is_bottom_value?(v)
        new_hash[header] = v
      else
        v = array_to_hash(v) if v.is_a?(Array)
        new_hash.merge! flatten(v, header + ".")
      end
    end
    new_hash
  end

  def self.convert(hash, filepath)
    csv    = {}
    index  = -1

    hash.each do |baby_hash|
      index += 1
      flatten(baby_hash).each do |k,v|
        csv[k]        = {} if !csv[k]
        csv[k][index] = v
      end
    end

    headers = csv.keys
    max_index = index # after it's been used for iteration

    File.open(filepath, 'w') do |f|
      f.puts headers.join(',')
      0.upto(max_index).each do |i|
        csv.each do |header, element|
          f.print(element[i])
          f.print ',' # currently adds an extra ','
        end
        f.puts ""
      end
    end
  end
end

# h = {
#   a: :a,
#   b: :b,
#   c: {
#     j: :j,
#     lol: :lol,
#     bro: {
#       truce: true,
#       gurl: :bro,
#       peanut: [
#         :for,
#         :real,
#         {
#           dude: :lernt
#         }
#       ]
#     }
#   }
# }
#
# require 'pp'
# pp h
# pp HashToCSV::flatten(h)
