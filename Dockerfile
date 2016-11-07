FROM perl:5.24.0
EXPOSE 3000
ADD dracilious /srv/dracilious/
WORKDIR /srv/dracilious/
RUN cpanm --installdeps .
RUN prove -Ilib -v -r t
CMD ["perl","script/dracilious","daemon"]