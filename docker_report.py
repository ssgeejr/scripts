import subprocess

process = subprocess.Popen("docker ps -aq -f status=exited", stdout=subprocess.PIPE, shell=True)
output = process.stdout.read()
output_lines = output.split(b'\n')
for line in output_lines:
        if line:
                print(line)
                second_command = "docker inspect %s --format='{{.Image}}'" % line
                print(second_command)

                processA = subprocess.Popen(("docker inspect %s --format='{{.Image}}'" % line), stdout=subprocess.PIPE, shell=True)
                outputA = processA.stdout.read()
                output_linesA = outputA.split(b'\n')
                for lineA in output_linesA:
                        if lineA:
                                print (lineA[7:])

                print('-------------------------------------------------')
                print('PROCESS-B')

                bcommand = "docker inspect %s --format='{{.Config.Image}}'" % line
                print(bcommand)
                processB = subprocess.Popen(bcommand, stdout=subprocess.PIPE, shell=True)
                outputB = processB.stdout.read()
                output_linesB = outputB.split(b'\n')
                for lineB in output_linesB:
                        if lineB:
                                print ('bcommand: ' + lineB)
