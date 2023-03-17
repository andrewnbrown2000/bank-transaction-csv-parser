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

transaction_data = csv_parser('C:\Users\Andrew\Desktop\budgetSheets\2022sheets\2022transactions.csv') # parse and clean csv, turn it into a 2D array


class Transaction
  attr_reader :date, :withdrawal, :deposit #r only
  attr_accessor :vendor #r/w
  def initialize(date, withdrawal, deposit, vendor)
    @date = date
    @withdrawal = withdrawal
    @deposit = deposit
    @vendor = if vendor.nil? # protects against csv file containing nil vendors
                'VENDOR UNKNOWN'
              else
                vendor
              end
  end
end

transaction_data.each do |transaction|
  transaction = Transaction.new(transaction[0], transaction[1], transaction[2], transaction[3]) # load objects with respective data
  if transaction.vendor.match?(/TERMINAL.*?\s{2}/) #if statements to trim the vendor strings
    transaction.vendor = transaction.vendor.match(/TERMINAL.*?\s{2}/).to_s
    if transaction.vendor.match?(/TERMINAL \d{6,7}\s+(.*)/)
      transaction.vendor = transaction.vendor.match(/TERMINAL \d{6,7}\s+(.*)/)[1]
    end
  end
  if transaction.vendor.match?(/TERMINAL [0-9]+ (.*?)\s+\b\w*\d/)
    transaction.vendor = transaction.vendor.match(/TERMINAL [0-9]+ (.*?)\s+\b\w*\d/)[1]
    puts transaction.vendor
  end
end