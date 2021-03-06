//
// The Openlayers Collection API mapping for purescript.
//
// Written by Tomas Stenlund, Sundsvall, Sweden (c) 2020
//
"use strict";

// Get hold of the OpenLayer types and functions
var ol  = require ('ol');

exports.createImpl = function (arr, opt) {
    return function() {
        var r = new ol.Collection(arr, opt);
        return r;
    }
}

exports.extendImpl = function (arr, self) {
    return self.extend (arr);
}

exports.getLengthImpl = function (self) {    
    return self.getLength();
}

exports.itemImpl = function (j, n, i, self) {
    if ((i>=0) && (i<self.getLength())) {
        return j(self.item(i));
    } else {
        return n;
    }
}
