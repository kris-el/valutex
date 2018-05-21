var config = {
    development: {
        //url to be used in link generation
        url: 'http://my.site.com',
        //mongodb connection settings
        database: {
            host:   '127.0.0.1',
            port:   '27017',
            db:     'site_dev'
        },
        //server details
        server: {
            host: '127.0.0.1',
            port: '3422'
        },
        fixer: {
          api_key: "4563b5e15c6ab7eef2426ae6403fed87"
        }
    },
    production: {
        //url to be used in link generation
        url: 'http://my.site.com',
        //mongodb connection settings
        database: {
            host: '127.0.0.1',
            port: '27017',
            db:     'site'
        },
        //server details
        server: {
            host:   '127.0.0.1',
            port:   '3421'
        },
        fixer: {
          api_key: "4563b5e15c6ab7eef2426ae6403fed87"
        }
    }
};
module.exports = config;
