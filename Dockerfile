FROM ruby:2.7.5

ENV RAILS_ENV=production


RUN gem install rails

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs graphviz

# chromeの追加
RUN apt-get update && apt-get install -y unzip && \
  CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
  wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
  unzip ~/chromedriver_linux64.zip -d ~/ && \
  rm ~/chromedriver_linux64.zip && \
  chown root:root ~/chromedriver && \
  chmod 755 ~/chromedriver && \
  mv ~/chromedriver /usr/bin/chromedriver && \
  sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
  apt-get update && apt-get install -y google-chrome-stable

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install
COPY . /myapp

RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y nodejs yarn postgresql-client

RUN wget https://moji.or.jp/wp-content/ipafont/IPAexfont/IPAexfont00401.zip
RUN unzip IPAexfont00401.zip
RUN mkdir -p /usr/share/fonts/ipa
RUN cp IPAexfont00401/*.ttf /usr/share/fonts/ipa
RUN fc-cache -fv

COPY start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["sh","/start.sh"]
