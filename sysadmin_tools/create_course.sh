#!/bin/bash

#
# Helper function to generate all the directories and the needed users for a particular course
#

# Default variables for users and courses. They follow the defaults as listed on the Submitty
# development documentation: https://submitty.org/developer/vm_install_using_vagrant
course=coursename
semester=01
section=section1
instructor=instructor
ta=ta

function create_course_users () {
    course=$1
    instructor=$2
    ta=$3

    sudo addgroup ${course}
    sudo addgroup ${course}_tas_www
    sudo addgroup ${course}_archive

    sudo adduser ${instructor} ${course}
    sudo adduser ${instructor} ${course}_tas_www
    sudo adduser ${instructor} ${course}_archive

    sudo adduser ${ta} ${course}_tas_www

    sudo adduser submitty_php ${course}_tas_www
    sudo adduser submitty_daemon ${course}_tas_www
    sudo adduser submitty_cgi ${course}_tas_www

    sudo service php7.2-fpm restart

    sudo adduser ${instructor} submitty_course_builders

    course_repo=/var/local/submitty/private_course_repositories/submitty_courses
    sudo mkdir -p ${course_repo}
    sudo chown -R ${instructor}:${course} ${course_repo}
    sudo chmod -R 770 ${course_repo}
    sudo chmod -R g+s ${course_repo}
}


create_course_users ${course} ${instructor} ${ta}

sudo /usr/local/submitty/sbin/create_course.sh ${semester} ${course} ${instructor} ${course}_tas_www

echo "Course has to be created at: /var/local/submitty/courses/${semester}/${course}/"

sudo service php7.2-fpm restart
sudo /usr/local/submitty/sbin/adduser.py --course ${semester} ${course} null ${instructor}

sudo su postgres -c \
     "psql -d submitty -c \"insert into courses_registration_sections values('${semester}', '${course}', '${section}');\""

echo "Clone the repository into the course_repo: /var/local/submitty/private_course_repositories/submitty_courses"


# Create links on ${instructor}'s home
sudo su -c "ln -s /var/local/submitty/courses/${semester}/${course} ~/" ${instructor}


## Create users and db
# this script
echo "To build a section go into ~${instructor}/${course} and run:"
echo "   ./BUILD_${course}.sh [exercise]"
