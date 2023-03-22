def csv_parser(file_path)
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

def trim_transaction(transaction)
  return if transaction.vendor.nil? || transaction.vendor.empty?

  if transaction.is_a?(Withdrawal)
    # transaction.vendor = transaction.vendor.gsub(' ', '') if transaction.vendor.match(' ')
    # transaction.vendor = transaction.vendor.match(/([0-9]+ )(([A-Za-z-'*]{0,9}  ?)+)/)[2] if transaction.vendor.match?(/([0-9]+ )(([A-Za-z-'*]{0,9}  ?)+)/)
    # transaction.vendor = transaction.vendor.match(/\d+ (\w-*&*\w+)/) if transaction.vendor.match?(/\d+ (\w-*&*\w+)/)
    # transaction.vendor = transaction.vendor.match(/(^\d+ )(.+)/)[2] if transaction.vendor.match?(/(^\d+ )(.+)/)
    # transaction.vendor = transaction.vendor.match(/(.+)( \d+$)/)[1] if transaction.vendor.match?(/(.+)( \d+$)/)
  elsif transaction.is_a?(Deposit)
    transaction.vendor.slice!(/  +.+/)[0] if transaction.vendor.match?(/  +/)
    transaction.vendor.slice!(/"/)[0] if transaction.vendor.match?(/"/)
    transaction.vendor.slice!(/(\w*\d\w*\s*)+$/)[0] if transaction.vendor.match?(/(\w*\d\w*\s*)+$/)
    transaction.vendor = transaction.vendor.match(/FR ACC (X+\d+)/) if transaction.vendor.match?(/FR ACC (X+\d+)/)
    transaction.vendor = transaction.vendor.to_s.match(/TERMINAL \d+\s(\w+).*/)[1] if transaction.vendor.to_s.match?(/TERMINAL \d+\s(\w+).*/)
  end
end

transaction_data = csv_parser('C:\Users\Andrew\Desktop\budgetSheets\2022sheets\2022transactions.csv') # parse and clean csv, turn it into a 2D array

class Transaction
  attr_accessor :date, :vendor, :value

  def initialize(date, value, vendor)
    @date = date
    @vendor = vendor
    @value = value
  end

end

class Deposit < Transaction

  def initialize(date, value, vendor)
    super
  end

end

class Withdrawal < Transaction

  def initialize(date, value, vendor)
    super
  end

end

transaction_data.each do |transaction|
  if transaction[2].nil? || transaction[2].empty?
    transaction = Withdrawal.new(transaction[0], transaction[1], transaction[3]) # init withdrawal
    transaction.vendor = 'NO VENDOR LISTED' if transaction.vendor.nil? || transaction.vendor == ''
  elsif transaction[1].nil? || transaction[1].empty?
    transaction = Deposit.new(transaction[0], transaction[2], transaction[3]) # init deposit
    transaction.vendor = 'NO VENDOR LISTED' if transaction.vendor.nil? || transaction.vendor == ''
  end

  trim_transaction(transaction)
  puts transaction.vendor if transaction.is_a?(Withdrawal)
end
