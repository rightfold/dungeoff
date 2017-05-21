'use strict';

var discord = require('discord.js');

exports.ffiNewClient = function() {
  return new discord.Client();
};

exports.ffiClientLogin = function(client) {
  return function(token) {
    return function(onError) {
      return function(onSuccess) {
        return function() {
          client.login(token).then(
            function(usedToken) { onSuccess(usedToken)(); },
            function(error) { onError(error)(); }
          );
        };
      };
    };
  };
};

exports.ffiClientChannels = function(client) {
  return function() {
    return client.channels;
  };
};

exports.ffiClientOnMessage = function(client) {
  return function(callback) {
    return function() {
      client.on('message', function(message) {
        callback(message)();
      });
    };
  };
};

exports.ffiCollectionGet = function(nothing) {
  return function(just) {
    return function(collection) {
      return function(key) {
        return function() {
          var value = collection.get(value);
          return value === undefined ? nothing : just(value);
        };
      };
    };
  };
};

exports.ffiMessageContent = function(message) {
  return function() {
    return message.content;
  };
};
