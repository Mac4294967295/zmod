import time
import os
#logfile = open("logs\\games_mp.log", "r")
while True:
    logfile = open("logs\\games_mp.log", "r")
    lines = logfile.readlines()
    logfile.close()
    print(len(lines))
    i = len(lines)-1
    output = []
    while i>=0:
        if lines[i].find("**************STATSSTART************")>=0:
            break
        start = lines[i].find("*STATS:")
        if start>=0:
            tuple = lines[i].partition("*STATS: ")
            print(len(tuple))
            print(len(output))
            print(tuple[2])
            output.append(tuple[2])
        i = i-1
        outputLines = []
    lines = output
    print(len(lines))
    for i in range(len(lines)):
        split = lines[i].split(",")
        split[0] = "\""+split[0]+"\""
        split[1] = "\""+split[1]+"\""
        lines[i] = split[0]
        for j in range(1, len(split)):
            lines[i] = lines[i]+", "+split[j]
        lines[i]="\tinitPlayerData("+lines[i][0:len(lines[i])-1]+");\n"
        print(lines[i])

    output = open("scripts\\_statsinit.gsc", "w")
    output.write("#include scripts\stats;\n\n")
    output.write("initializeStats(){\n")
    for line in lines:
        output.write(line)
    output.write("}")
    output.close()
    time.sleep(5)
