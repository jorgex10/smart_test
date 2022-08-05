class Parser
  attr_reader :file, :results

  IP_REGEX = /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/

  def initialize(file)
    @file = file[0]
    @results = {}
  end

  def call
    raise(StandardError, 'We need filename argument') if file.nil?

    parse_process
    show_results
  end

  private

  def parse_process
    File.open("#{file}", 'r') do |f|
      f.each_line do |line|
        splitted_line = line.split(' ')
        next unless valid_ip?(splitted_line[1])

        key = splitted_line[0].to_sym
        results[key].nil? ? results[key] = 1 : results[key] += 1
      end
    end
  end

  def show_results
    puts "\n------------------------------- *"
    results.each { |result| puts "#{result[0].to_s} have #{result[1].to_s} visits" }
    puts "------------------------------- *\n\n"
  end

  def valid_ip?(ip)
    ip =~ IP_REGEX
  end
end

# EXECUTION
Parser.new(ARGV).call if $PROGRAM_NAME == __FILE__
