require 'time'

module Logger
  LOG_FILE = "app.log"

  def log_info(message)
    write_log("info", message)
  end

  def log_warning(message)
    write_log("warning", message)
  end

  def log_error(message)
    write_log("error", message)
  end

  private

  def write_log(type, message)
    timestamp = Time.now.iso8601
    line = "#{timestamp} #{type} -> #{message}\n"
    File.open(LOG_FILE, "a") { |f| f.write(line) }
  end
end

class User
  attr_accessor :name, :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end

  def to_s
    "User #{@name}"
  end
end

class Transaction
  attr_reader :user, :value

  def initialize(user, value)
    @user = user
    @value = value
  end

  def to_s
    "#{@user} transaction with value #{@value}"
  end
end

class Bank
  def process_transactions(transactions, &block)
    raise NotImplementedError, "#{self.class} must implement process_transactions"
  end
end

class CBABank < Bank
  include Logger

  def initialize(users)
    @users = users
  end

  def process_transactions(transactions, &block)
    transaction_list = transactions.map { |t| t.to_s }.join(", ")
    log_info("processing transactions #{transaction_list}...")

    transactions.each do |transaction|
      user    = transaction.user
      value   = transaction.value
      success = false
      reason  = nil

      begin
        # check if user belongs to this bank
        unless @users.include?(user)
          raise "#{user.name} not exist in the bank"
        end

        # check if transaction would make balance go below 0
        if user.balance + value < 0
          raise "not enough balance"
        end

        # apply the transaction
        user.balance += value

        # warn if balance hits exactly 0
        if user.balance == 0
          log_warning("#{user.name} has 0 balance")
        end

        log_info("#{transaction} succeeded")
        success = true

      rescue RuntimeError => e
        reason = e.message
        log_error("#{transaction} failed with message #{reason}")
        success = false
      end

      # call the callback block with the result
      if success
        block.call("success", transaction, nil)
      else
        block.call("failure", transaction, reason)
      end
    end
  end
end

users = [
  User.new("yusuf1", 200),
  User.new("yusuf2", 500),
  User.new("yusuf3", 100)
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(User.new("yusuf4", 400), -100)  # outsider
]

bank = CBABank.new(users)  # only users[] belong to this bank

bank.process_transactions(transactions) do |status, transaction, reason|
  if status == "success"
    puts "success #{transaction}"
  else
    puts "failure #{transaction} with reason #{reason}"
  end
end