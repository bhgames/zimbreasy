class ZimbreasyTimeoutException < Exception
  def message
    'Request timed out after multiple retries.'
  end
end
