local Functions = { };

function Functions:keycheck(key)
    return (key .. "X"):sub(1, -2) == "styxrelease"
end

if not keycheck(getgenv().keysystem) then
    print("enter the right key nigger")
    task.wait(math.random(1, 3))
    return
end

print("thanks!!")

-- // a really shit key system, changing it later
