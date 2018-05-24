var env = process.env.NODE_ENV || 'development';

if (env === 'development') {
  process.env.PORT = 3000;
  process.env.MONGODB_URI = 'mongodb://localhost:27017/Valuta';
  process.env.FIXER_KEY = '002b7a56431b0323f925171ec329ddf2';
} else if (env === 'test') {
  process.env.PORT = 3000;
  process.env.MONGODB_URI = 'mongodb://localhost:27017/ValutaTest';
  process.env.FIXER_KEY = '002b7a56431b0323f925171ec329ddf2';
}
