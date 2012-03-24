require 'webrick'

class NonCachingFileHandler < WEBrick::HTTPServlet::FileHandler
  def prevent_caching(res)
    res['ETag']          = nil
    res['Last-Modified'] = Time.now + 100**4
    res['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0'
    res['Pragma']        = 'no-cache'
    res['Expires']       = Time.now - 100**4
  end
  
  def do_GET(req, res)
    super
    prevent_caching(res)
  end
end

class WhiteCastle
  def self.start(options)
    server = WEBrick::HTTPServer.new(
      :Port           => options[:port],
      :FancyIndexing  =>    true
    )
    server.mount "/", WEBrick::HTTPServlet::FileHandler, './'
    trap('INT') { server.stop }
    server.start
  end
end