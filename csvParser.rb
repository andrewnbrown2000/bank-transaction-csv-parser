file_contents = File.read 'transactions.csv'

header = []
table = []

file_contents = file_contents.split("\n").reject(&:empty?).join("\n")

file_contents.each_line do |line|
  if line.start_with? '<' # its a header
    # remove the trailing \n, remove the <'s and >'s, split on commas.
    # this gives an array of the column names
    header = line.gsub("\n", '').gsub('<', '').gsub('>', '').split(',')
  else
    # this method will split on commas not in parentheses
    table << line.split(/(?!\B"[^"]*),(?![^"]*"\B)/)
  end
end

# convert table from [row #][column #] to [row #][column name]
table.collect! do |row|
  column_names = header.each
  hash = {}
  row.each { |field| hash[column_names.next] = field }
  hash
end

# for each row
table.collect! do |row|
  # if additional info on this row has terminal then a number then a date
  if row['Additional Info'].match?(/TERMINAL\s\d+\s(.*?)\s+\d+-/)
    # only take the values after (terminal number) and before the date
    row['Additional Info'] = row['Additional Info'].match(/TERMINAL\s\d+\s(.*?)\s+\d+-/)[1]
    # only keep words that don't have digits, replace all spaces of greater than one space with a single space
    row['Additional Info'] = row['Additional Info'].gsub(/\b\w*\d\w*\b/, '').gsub(/\s\s+/, ' ')
  end
  row
end

puts table
