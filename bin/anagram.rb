#!/usr/bin/env ruby
require 'optparse'

#Crea las opciones (parser de la línea de comandos)
dictionary = "/usr/share/dict/words"
OptionParser.new do |opts|
  opts.banner = "Usage: anagram [ options ] word ..."
  opts.on("-d", "--dict path", String, "Path to dictionary") do |dict|
    dictionary = dict
  end
  opts.on("-h", "--help", "Show this message") do
    puts opts
    exit
  end
  
  #Si las opciones se introducen mal, aparece un mesanje de error y se imprimen las opciones correctas generadas anteriormente
  begin
    ARGV << '-h' if ARGV.empty?
    opts.parse!(ARGV)
    rescue OptionParser::ParseError => e
      STDERR.puts e.message,"\n",opts
      exit(-1)
  end
end


def signature_of(word)
  word.unpack("c*").sort.pack("c*")
end

#Creo un elemento hash, donde cada elemento si no está inicializado, se inicializa a un aray vacío
signatures = Hash.new { |h,k| h[k] = [] }
File.foreach(dictionary) do |line|
  word = line.chomp #chomp elimina el retorno de carro
  signature = signature_of(word)
  signatures[signature] << word #signatures es una tabla hash no un array
end


ARGV.each do |word|
  s = signature_of(word)
  if signatures[s].length != 0
    puts "Anagrams of '#{word}': #{signatures[s].join(', ')}"
  else
    puts "No anagrams of '#{word}' found in #{dictionary}"
  end
end