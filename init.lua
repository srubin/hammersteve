-- Avoid automatically setting a bluetooth audio input device

lastSetOutputDeviceTime = os.time()
lastInputDevice = nil

function audioDeviceChanged(arg)
    if arg == 'dOut' then
        lastSetOutputDeviceTime = os.time()
    elseif arg == 'dIn ' and os.time() - lastSetOutputDeviceTime < 2 then
        inputDevice = hs.audiodevice.defaultInputDevice()
        if inputDevice:transportType() == 'Bluetooth' then
            internalMic = lastInputDevice or hs.audiodevice.findInputByName('Built-in Microphone')
            internalMic:setDefaultInputDevice()
        end
    end
    lastInputDevice = hs.audiodevice.defaultInputDevice()
end

hs.audiodevice.watcher.setCallback(audioDeviceChanged)
hs.audiodevice.watcher.start()
