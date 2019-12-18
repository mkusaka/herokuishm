require "get_process_mem"

app = ->(_) { [200, { "Content-Type" => "text/plain" }, ["OK (#{GetProcessMem.new.bytes.to_s("F")}bytes)"]] }
run app
