wifi.setmode(wifi.STATION)
wifi.sta.config("SSID", "PASSWORD")

 -- Inicialisar un servidor http
    srv = net.createServer(net.TCP)
    srv:listen(80, function(conn)
    conn:on("receive", function(sck, payload)
        print(payload)
        moist_value=adc.read(0)
        alerta="HUMEDAD_OK"

        -- Faltan mejoras en mediciones
        if(moist_value>600) then
            alerta="FALTA_HUMEDAD"
        elseif(moist_value<600) then
            alerta="HUMEDAD_OK"
        end
        
        print(moist_value)
        sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Humedad de planta by NodeMCU</h1><br> Humedad: "..moist_value.."<br>Alerta: "..alerta.."")
            
        http.post('http://requestb.in/1n1li3l1',
          'Content-Type: application/json\r\n',
          '{"humedad":'..moist_value..'},{"alerta":"'..alerta..'"}',
          function(code, data)
            if (code < 0) then
              print("HTTP request failed")
            else
              print(code, data)
            end
          end)
  
    end)
    conn:on("sent", function(sck) sck:close() end)
end)
