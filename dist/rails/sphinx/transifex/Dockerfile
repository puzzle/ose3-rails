FROM puzzle/ose3-rails-sphinx:ruby22

      
      
      

USER root

ADD /contrib/bin/install-transifex.sh $STI_SCRIPTS_PATH
RUN scl enable rh-ruby22 $STI_SCRIPTS_PATH/install-transifex.sh 
