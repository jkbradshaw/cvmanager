# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cvm_session',
  :secret      => '2638e9fa27d88a82d42a70ca010c167e13a684d59556339e00af2a18a6d70d74f27d1fe378f60a44479a009ad31c501f5229586a59a1398da6f636150fd4a48f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
