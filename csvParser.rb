def csv_parser file_path
  csv_lines = File.read(file_path).split(/\n/).reject do |line| # read in the file and clean it up by removing blank lines and headers
    line.empty? or line.start_with?('<')                            # and setting it equal to an array "csv_lines"
  end
  csv_items_arr = csv_lines.map do |line| # split the created array into a 2d array. Big array is all transactions, and small arrays
    line.split(',')                         # represent a transaction and its data
  end
  csv_items_arr.each do |transaction| # remove 1st and 2nd element of each array, they are useless
    transaction.slice!(1..2)
  end
end

transaction_data = csv_parser('C:\Users\Andrew\Desktop\budgetSheets\transactions.csv') # parse and clean csv, turn it into a 2D array


class Transaction
  attr_reader :date, :withdrawal, :deposit, :vendor
  def initialize(date, withdrawal, deposit, vendor)
    @date = date
    @withdrawal = withdrawal
    @deposit = deposit
    @vendor = vendor

  end
end

transaction_data.each do |transaction|
  transaction << Transaction.new(transaction[0], transaction[1], transaction[2], transaction[3])
  transaction[3].slice!(/(?<=\d{6,7}\s+).*?(?=(\d|\s\s))/)
  puts "#{transaction} + ***"
  # transactions \\<< Transaction.send([:new] + transaction)
end


# will need to do a regex here to combine vendors. might further consolidate into categories (i.e. food, gas, etc) if possible?
# puts 'combine the transaction data with the preexisting vendor data' if vendors.include?(vendor)
