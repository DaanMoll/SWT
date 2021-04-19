(function(e, a) { for(var i in a) e[i] = a[i]; }(window, /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(1);
__webpack_require__(2);
module.exports = __webpack_require__(3);


/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

/* globals $:false */
/* global
    isFromMatlabOnline,
    isMatlabColonLink,
    getSelectedUrl,
    setupFinished,
    handleMatlabColonLink
*/
$(document).ready(initMatlabOnline);

window._appendDocViewerParameter = _appendDocViewerParameter;

function initMatlabOnline () {
    if (isFromMatlabOnline()) {
        if (window.parent && window.parent.location !== window.location) {
            $(window).bind('examples_cards_added', function (e) {
                $('.card_container a[href^="matlab:"]').off('click');
                handleMatlabColonLink();
            });
            _handleMatlabOnlineDocLinksClick();
            setupFinished();
        } else {
            clearMatlabOnlineDocViewer(); // reset the cookies
        }
    }
}

function clearMatlabOnlineDocViewer () {
    var docviewerCookie = 'MW_Doc_Template';
    document.cookie = docviewerCookie + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;path=/help';
}

function _handleMatlabOnlineDocLinksClick () {
    $(window).bind('click', 'a', function (evt) {
        if (evt.target) {
            var href = getSelectedUrl(evt.target);
            if (href) {
                if (!isMatlabColonLink(href) && (evt.target.target !== '_blank')) {
                    evt.originalEvent.target.href = _appendDocViewerParameter(href);
                }
            }
        }
    });
}

function _appendDocViewerParameter (href) {
    var docViewerParamIdx = href.indexOf('docviewer=ml_online');
    if (docViewerParamIdx !== -1) {
        return href; // already have, return
    }

    var appendHref = href.indexOf('?') > 0 ? '&' : '?';
    appendHref += 'docviewer=ml_online';

    var hashIndex = href.indexOf('#');
    if (hashIndex === -1) {
        return href + appendHref;
    } else {
        return href.substring(0, hashIndex) + appendHref + href.substring(hashIndex, href.length);
    }
}

if (true) {
    exports._appendDocViewerParameter = _appendDocViewerParameter; // for test
}


/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

// TODO: automate generate this file
function getDocRelease () {
    return 'R2021a';
}

if (true) {
    exports.getDocRelease = getDocRelease;
}


/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

/* globals $:false */
/* global
*/
window.initDeferred = $.Deferred();
window.helpService = {
    'timestampCtr': 0,
    'callbacks': {},

    'callMessageService': function (channel, data, callback) {
        var msgDeferred = $.Deferred();
        msgDeferred.then(callback);
        var id = channel + '_' + window.performance.now() + '' + this.timestampCtr++;

        this.registerCallbackDeferred(msgDeferred, id);
        var messageObj = {
            'channel': channel,
            'data': data,
            'id': id
        };
        helpserviceIframePostMessage(messageObj);
    },

    'registerCallbackDeferred': function (deferredObj, id) {
        var cb = this.callbacks;
        cb[id] = deferredObj;

        setTimeout(function () {
            if (cb[id] && deferredObj.state() === 'pending') {
                delete cb[id];
                deferredObj.reject();
            }
        }, 10000);
    },

    'docDomRequestHandler': {
        back: function () {
            window.history.back();
        },
        forward: function () {
            window.history.forward();
        },
        find: function (msgEvt) {
            var strFound = window.find(msgEvt.data.findstring, msgEvt.data.casesensitive, msgEvt.data.backwards, true);
            var id = 'docinfo_' + new Date().getTime();
            var messageObj = {
                'domchannel': 'domeventinfo',
                'domevent': 'findresponse',
                'eventData': '',
                'id': id
            };
            if (!strFound) {
                messageObj['eventData'] = 'false';
            } else {
                messageObj['eventData'] = 'true';
            }
            helpserviceIframePostMessage(messageObj);

            // Try scrolling the selection into view.
            if (strFound) {
                try {
                    window.getSelection().anchorNode.parentElement.scrollIntoViewIfNeeded();
                } catch (e) {
                    // Do nothing.
                }
            }
        },
        clearselection: function () {
            if (window.getSelection) {
                if (window.getSelection().empty) { // Chrome
                    window.getSelection().empty();
                } else if (window.getSelection().removeAllRanges) { // Firefox
                    window.getSelection().removeAllRanges();
                }
            } else if (document.selection) { // IE?
                document.selection.empty();
            }
        },
        print: function (msgEvt) {
            var messageObj = {
                'domchannel': 'domeventinfo',
                'domevent': 'printresponse',
                'eventData': msgEvt.data.id
            };
            helpserviceIframePostMessage(messageObj);
            window.print();
        }
    },

    'receiveMessage': function (msgEvt) {
        var id = msgEvt.data.id;
        if (this.callbacks[id]) {
            this.callbacks[id].resolve(msgEvt.data.data);
            delete this.callbacks[id];
        }

        if (msgEvt.data.domchannel) {
            if (msgEvt.data.domchannel === 'domeventinfo') {
                if (msgEvt.data.domevent) {
                    this.docDomRequestHandler[msgEvt.data.domevent](msgEvt);
                }
            }
        }
    }
};

var helpServicesInitialized = false;

function getSessionStorageItem (key) {
    if (!helpServicesInitialized) {
        initHelpServices();
    }
    return _getSessionStorageForKey(key);
}

function isSessionStorageItem (key, value) {
    if (!helpServicesInitialized) {
        initHelpServices();
    }
    return _isSessionStorageContains(key, value);
}

$(document).ready(initHelpServices);

function initHelpServices () {
    if (helpServicesInitialized) {
        return;
    }

    var browserContainerKey = 'help_browser_container';
    var browserContainerValue = 'jshelpbrowser';

    // MOS: to uncomment this
    // document.cookie = "MW_Doc_Template=ONLINE||||||||||";

    _detectBrowserProperties('container=jshelpbrowser', browserContainerKey, browserContainerValue);
    _detectBrowserProperties('linkclickhandle=csh', 'link_handle_type', 'csh');
    _detectBrowserProperties('browser=F1help', 'hide_new_tab_menu', 'true');

    var searchSourceKey = 'searchsource';
    var searchSourceValue = getQueryStringValue(searchSourceKey);
    if (searchSourceValue) {
        _detectBrowserProperties(searchSourceKey, searchSourceKey, searchSourceValue);
    }

    var helpBrowserContainer = _getSessionStorageForKey(browserContainerKey);

    if (window.parent && window.parent.location !== window.location) {
        window.helpserviceframe = window.parent;
        // We are in an iframe, presumably the JavaScript Help Browser's
        // help panel.
        if (helpBrowserContainer && helpBrowserContainer === browserContainerValue) {
            handleContextMenu();
            handleDomKeyDown();
            registerUninstalledDocLink();
            handleDocLinksClick();
            handleMiddleMouseClick();
            handleMouseOverAndOutOnLink();
            registerWindowOnLoadAction();
            setupFinished();
            handleWindowOpen();
            handleTitleChange();
        }
    } else if (window.location.origin.match(/^https?:\/\/localhost.*/)) {
        // This looks like local doc served by the connector but not
        // in the JavaScript Help Browser.
        if (!isFromMatlabOnline()) {
            window.helpserviceframe = createHelpServiceFrame();
            handleDocLinksClick();
        }
    }

    if (window.helpserviceframe) {
        handleMatlabColonLink();
    }

    helpServicesInitialized = true;
}

function _detectBrowserProperties (urlFeatureParameter, featureKey, featureValue) {
    if (window.location.href && window.location.href.indexOf(urlFeatureParameter) > 0) {
        window.sessionStorage.setItem(featureKey, featureValue);
    }
}

function getQueryStringValue (key) {
    var value;
    try {
        value = decodeURIComponent(window.location.search.replace(new RegExp('^(?:.*[&\\?]' + encodeURIComponent(key).replace(/[.+*]/g, '\\$&') + '(?:\\=([^&]*))?)?.*$', 'i'), '$1'));
    } catch (e) {
        value = null;
    }
    return value;
}

function handleContextMenu () {
    var contextMenuAction = function (e) {
        var id = 'docinfo_' + new Date().getTime();

        var selectedText = getSelectedText();
        var selectedUrl = getSelectedUrl(e.target);
        if (_isEnglishRedirect(selectedUrl)) {
            selectedUrl = _replaceEnglishRoute(selectedUrl);
        } else {
            selectedUrl = _normalizeEnglishRoute(selectedUrl);
        }

        var browserContainerKey = 'help_browser_container';
        var isHideOpenNewTab = _isSessionStorageContains('hide_new_tab_menu', 'true');

        var pageUrl = window.location.href;
        pageUrl = _normalizeEnglishRoute(pageUrl);

        var messageObj = {
            'domchannel': 'domeventinfo',
            'title': window.document.title,
            'url': pageUrl,
            'domevent': 'contextmenu',
            'eventData': {
                'pageX': e.pageX,
                'pageY': e.pageY,
                'clientX': e.clientX,
                'clientY': e.clientY,
                'selectedText': selectedText,
                'selectedUrl': selectedUrl,
                'isHideOpenNewTab': isHideOpenNewTab,
                'helpBrowserContainer': _getSessionStorageForKey(browserContainerKey)
            },
            'id': id
        };
        e.preventDefault();
        helpserviceIframePostMessage(messageObj);
    };

    $('body').contextmenu(contextMenuAction);
}

function _getSessionStorageForKey (key) {
    var value;
    try {
        value = window.sessionStorage.getItem(key);
    } catch (e) {
        value = null;
    }
    return value;
}

function _isSessionStorageContains (key, value) {
    return value === window.sessionStorage.getItem(key);
}

function handleDomKeyDown () {
    var keyDownAction = function (e) {
        var id = 'docinfo_' + new Date().getTime();

        var nativeEvent = document.createEvent('HTMLEvents');
        nativeEvent.initEvent('keydown', !!e.bubbles, !!e.cancelable);
        // and copy all our properties over
        for (var i in e) {
            nativeEvent[i] = e[i];
        }

        var selectedText = getSelectedText();
        var selectedUrl = getSelectedUrl(e.target);
        if (_isEnglishRedirect(selectedUrl)) {
            selectedUrl = _replaceEnglishRoute(selectedUrl);
        } else {
            selectedUrl = _normalizeEnglishRoute(selectedUrl);
        }
        var pageUrl = window.location.href;
        pageUrl = _normalizeEnglishRoute(pageUrl);

        var browserContainerKey = 'help_browser_container';
        var helpBrowserContainer = _getSessionStorageForKey(browserContainerKey);

        nativeEvent['selectedText'] = selectedText;
        nativeEvent['selectedUrl'] = selectedUrl;
        nativeEvent['helpBrowserContainer'] = helpBrowserContainer;

        var nativeEventObj = JSON.parse(simpleStringify(nativeEvent));

        var messageObj = {
            'domchannel': 'domeventinfo',
            'title': window.document.title,
            'url': pageUrl,
            'domevent': 'keydown',
            'eventData': nativeEventObj,
            'id': id
        };

        helpserviceIframePostMessage(messageObj);
    };
    window.addEventListener('keydown', keyDownAction);
}

function simpleStringify (object) {
    var simpleObject = {};
    for (var prop in object) {
        if (!object.hasOwnProperty(prop)) {
            continue;
        }
        if (typeof (object[prop]) === 'object') {
            continue;
        }
        if (typeof (object[prop]) === 'function') {
            continue;
        }
        simpleObject[prop] = object[prop];
    }
    return JSON.stringify(simpleObject); // returns cleaned up JSON
}

function registerWindowOnLoadAction () {
    window.addEventListener('load', function (e) {
        if (window.parent && window.parent.location !== window.location) {
            // We are in an iframe, presumably the JavaScript Help Browser's
            // help panel.
            var id = 'docinfo_' + new Date().getTime();
            var htmlSource = document.getElementsByTagName('html')[0].outerHTML;
            var pageUrl = window.location.href;
            pageUrl = _normalizeEnglishRoute(pageUrl);
            var messageObj = {
                'domchannel': 'domeventinfo',
                'domevent': 'onload',
                'title': window.document.title,
                'url': pageUrl,
                'htmlsource': htmlSource,
                'id': id
            };

            helpserviceIframePostMessage(messageObj);
        }
    }, { once: true });
}

function handleTitleChange () {
    // Set up an observer for the title element.
    var target = document.querySelector('head > title');
    var observer = new window.MutationObserver(function (mutations) {
        mutations.forEach(function (mutation) {
            var newtitle = mutation.target.textContent;
            var id = 'docinfo_' + new Date().getTime();
            var messageObj = {
                'domchannel': 'domeventinfo',
                'domevent': 'titlechange',
                'newtitle': newtitle,
                'id': id
            };
            helpserviceIframePostMessage(messageObj);
        });
    });
    observer.observe(target, { subtree: true, characterData: true, childList: true });
}

(function (history) {
    var pushState = history.pushState;
    history.pushState = function (state) {
        if (typeof history.onpushstate === 'function') {
            history.onpushstate({ state: state });
        }

        handleHistoryChange();
        return pushState.apply(history, arguments);
    };
    window.onpopstate = function (evt) {
        handleHistoryChange();
    };
})(window.history);

function handleHistoryChange () {
    if (window.parent && window.parent.location !== window.location) {
        // We are in an iframe, presumably the JavaScript Help Browser's
        // help panel.
        var id = 'docinfo_' + new Date().getTime();
        var messageObj = {
            'domchannel': 'domeventinfo',
            'domevent': 'historystatechange',
            'id': id
        };
        helpserviceIframePostMessage(messageObj);
        setTimeout(function () {
            helpserviceIframePostMessage(messageObj);
        }, 1000);
    }
}

function handleWindowOpen () {
    window.open = function (url, name, features) {
        if (url) {
            callMessageService('windowopen', { 'link': url }, function () {});
        }
    };
}

function handleMouseOverAndOutOnLink () {
    $(window).bind('mouseenter', 'a', mouseOnLinkEventHandler);
    $(window).bind('mouseleave', 'a', mouseOnLinkEventHandler);
}

function mouseOnLinkEventHandler (evt) {
    if (evt.target) {
        var href = getSelectedUrl(evt.target);
        if (href) {
            callMessageService(evt.type + 'link', { 'link': href }, function () {});
        }
    }
}

function helpserviceIframePostMessage (msgObject) {
    if (window.helpserviceframe) {
        window.helpserviceframe.postMessage(msgObject, '*');
    }
}

// -------------- Start: Dom Access Helper functions ----------------------

function getSelectedText () {
    var text = '';
    if (window.getSelection) {
        text = window.getSelection().toString();
    } else if (window.document.selection &&
        window.document.selection.type !== 'Control') {
        text = window.document.selection.createRange().text;
    }
    return text;
}

function getSelectedUrl (targetNode) {
    var link = '';
    if (targetNode) {
        var cur = targetNode;
        while (cur && !isAnchor(cur)) { // keep going up until we find a match
            cur = cur.parentElement; // go up
        }

        if (cur && cur.href) {
            return cur.href;
        }
    }
    return link;
}

function isAnchor (el) {
    var selector = 'a';
    return (el.matches || el.matchesSelector || el.msMatchesSelector || el.mozMatchesSelector ||
    el.webkitMatchesSelector || el.oMatchesSelector).call(el, selector);
}
// -------------- End: Dom Access Helper functions ----------------------

function createHelpServiceFrame () {
    var ifrm = document.createElement('iframe');
    var hsUrl = window.location.origin + '/ui/help/helpbrowser/helpbrowser/helpservices.html';
    ifrm.setAttribute('src', hsUrl);
    ifrm.setAttribute('onLoad', 'setupFinished();');
    ifrm.style.width = '0px';
    ifrm.style.height = '0px';
    document.body.appendChild(ifrm);
    return $(ifrm).get(0).contentWindow;
}

function handleMatlabColonLink () {
    $(document).on('click', 'a[href^="matlab:"]', function (evt) {
        if (evt.target) {
            var href = getSelectedUrl(evt.target);
            var pageUrl = window.location.href;
            pageUrl = _normalizeEnglishRoute(pageUrl);
            if (href && isMatlabColonLink(href)) {
                evt.preventDefault();
                var messageObj = {
                    'url': href,
                    'currenturl': pageUrl
                };
                callMessageService('matlab', messageObj, function () {});
            }
        }
    });
}

function handleDocLinksClick () {
    $(window).bind('click', 'a', function (evt) {
        if (evt.target) {
            var href = getSelectedUrl(evt.target);
            if (href && !isMatlabColonLink(href) && (!href.match(/javascript:/))) {
                var currentPageHost = window.location.host;
                var currentPageProtocol = window.location.protocol;
                var pageUrl = window.location.href;
                pageUrl = _normalizeEnglishRoute(pageUrl);

                if (href &&
                   (href.indexOf(currentPageProtocol) < 0 || href.indexOf(currentPageHost) < 0) &&
                   href.indexOf('http') === 0 &&
                   (!_isLocalConnectorUrl(href)) &&
                   (!isWebDocUrl(href))) {
                    evt.preventDefault();
                    callMessageService('externalclick', { 'url': href }, function () {});
                } else if (_isExternalLinkForWebDoc(pageUrl, href)) {
                    // external link click for web doc
                    evt.preventDefault();
                    callMessageService('externalclick', { 'url': href }, function () {});
                } else if ((evt.target.target && evt.target.target === '_blank') || evt.ctrlKey) {
                    evt.preventDefault();
                    var openNewTabMsgObj = {
                        'openaction': 'newtab',
                        'openurl': href,
                        'selecttab': 'false'
                    };
                    callMessageService('openbrowserstrategy', openNewTabMsgObj, function () {});
                } else if (_isEnglishRedirect(href)) {
                    evt.originalEvent.target.href = _replaceEnglishRoute(href);
                } else if (_isEnglishRoute(href)) {
                    evt.originalEvent.target.href = _normalizeEnglishRoute(href);
                }
            }
        }
    });
}

function _isExternalLinkForWebDoc (pageUrl, href) {
    // A link is external for web doc if:
    // 1) The page we're on:
    //    a) is not a connector url
    //    b) is under the web doc
    // 2) The page we're navigating to:
    //    a) is not a connector url
    //    b) is not under the web doc
    if ((!_isLocalConnectorUrl(pageUrl)) &&
        (pageUrl.indexOf('mathworks.com/help') > 0) &&
        (!_isLocalConnectorUrl(href)) &&
        (_notWebDoc(href))) {
        return true;
    }
    return false;
}

function _notWebDoc (href) {
    // A web doc page is not web doc if:
    // 1) It's not under the help
    // OR
    // 2) It's under the archived doc, pdf_doc
    //    When viewed in the help broswer, pdf doc is not treated as web doc,
    //    it's treated as an exteranl link
    var underHelp = (href.indexOf('mathworks.com/help') > 0);
    var pdfDoc = (!underHelp ? false : _isArchivePdfDoc(href));
    return ((!underHelp) || pdfDoc);
}

function _isRequestFromArchiveArea (pageUrl) {
    return /.*\/help\/releases\/R20\d\d[ab]\/.*/.test(pageUrl);
}

function _isArchivePdfDoc (href) {
    var archiveDoc = _isRequestFromArchiveArea(href);
    var archivePdfDoc = (!archiveDoc ? false : (href.indexOf('pdf_doc') > 0));
    return archivePdfDoc;
}

function isWebDocUrl (href) {
    var url = new URL(href);
    var searchParams = new URLSearchParams(url.search.slice(1));
    return searchParams.has('webdocurl');
}

function isMatlabColonLink (href) {
    return href.match(/^\s*matlab:(.*)/i);
}

function handleMiddleMouseClick () {
    $(window).bind('mousedown', 'a', function (evt) {
        if (evt.target) {
            var href = getSelectedUrl(evt.target);
            if (href && !isMatlabColonLink(href)) {
                if (_isMiddleMouse(evt)) {
                    evt.preventDefault();
                    var openNewTabMsgObj = {
                        'openaction': 'newtab',
                        'openurl': href,
                        'selecttab': 'false'
                    };
                    callMessageService('openbrowserstrategy', openNewTabMsgObj, function () {});
                }
            }
        }
    });
}

function registerUninstalledDocLink () {
    // apply for all product doc.
    if (_isProductDocUrl(window.location.href)) {
        $('a').bind('click', handleUninstalledDocLink);
    }
}

function _isMiddleMouse (evt) {
    return evt.which === 2;
}

function _isProductDocUrl (href) {
    // Is this a local connector url (installed doc) or a web doc url from the archive area?
    return _isLocalConnectorUrl(href) || _isRequestFromArchiveArea(href);
}

function handleUninstalledDocLink (evt) {
    var href = $(this).prop('href'); // will return full url based on current href
    var hrefAttr = $(this).attr('href'); // will return actual href text
    if (href && (!href.match(/javascript:/i)) && !isMatlabColonLink(href) && _isProductDocUrl(href) && !_isMiddleMouse(evt) && !evt.ctrlKey && hrefAttr.indexOf('#') !== 0 && evt.target.target !== '_blank') {
        evt.preventDefault();
        var aTag = this;

        if (callMessageService) {
            callMessageService('doclink', { 'source': document.location.href, 'target': aTag.href }, function (response) {
                if (response.response === 'ok') {
                    var pageUrl = window.location.href;
                    pageUrl = _normalizeEnglishRoute(pageUrl);
                    if (_isSessionStorageContains('link_handle_type', 'csh') && (href.indexOf('#') !== 0)) {
                        var clickedUrl = getSelectedUrl(evt.target);
                        var openDocMessageObj = {
                            'url': clickedUrl.replace('browser=F1help', ''),
                            'currenturl': pageUrl
                        };
                        callMessageService('openhelpbrowser', openDocMessageObj, function () {});
                    } else {
                        $(aTag).unbind('click');
                        aTag.click();
                    }
                } else {
                    var webUrl = (_isSessionStorageContains('link_handle_type', 'csh') ? response.data.replace('browser=F1help', '') : response.data);
                    var messageObj = {
                        'domchannel': 'domeventinfo',
                        'domevent': 'pagenotinstalled',
                        'weburl': webUrl
                    };
                    helpserviceIframePostMessage(messageObj);
                }
            });
        }
    }
}

// this method only used when initial click on the link with 'lang=en' parameter
function _isEnglishRedirect (href) {
    return href && href.indexOf('lang=en') >= 0 && _isLocalConnectorUrl(href);
}

function _isEnglishRoute (href) {
    return href && href.indexOf('/static/en/help/') >= 0 && _isLocalConnectorUrl(href);
}

function _isLocalConnectorUrl (url) {
    if (!url) {
        return url;
    }
    return url.indexOf('https://localhost') >= 0;
}

function isConnectorUrl (url) {
    return _isLocalConnectorUrl(url);
}

function _replaceEnglishRoute (url) {
    if (!url) {
        return url;
    }
    return url.replace(/\/static\/help\//, '/static/en/help/');
}

function _normalizeEnglishRoute (url) {
    if (!url) {
        return url;
    }
    return url.replace(/\/static\/en\/help\//, '/static/help/');
}

function setupFinished () {
    window.initDeferred.resolve();
    window.addEventListener('message', function (msgEvt) {
        this.helpService.receiveMessage(msgEvt);
    });
}

function requestHelpService (params, services, callback, errorhandler) {
    var servicePrefs;
    try {
        servicePrefs = $.parseJSON(window.sessionStorage.getItem('help_preferred_services'));
    } catch (e) {
        servicePrefs = null;
    }

    if (!servicePrefs) {
        // TODO: We must be able to do better here.
        if (window.helpserviceframe && _isLocalConnectorUrl(window.location.href)) {
            callMessageService('servicepref', document.location.href, function (data) {
                window.sessionStorage.setItem('help_preferred_services', JSON.stringify(data));
                doServiceRequest(data, params, services, callback, errorhandler);
            });
        } else {
            servicePrefs = getServicePrefsForNonConnectorDoc();
            if (servicePrefs && servicePrefs.length > 0) {
                window.sessionStorage.setItem('help_preferred_services', JSON.stringify(servicePrefs));
                doServiceRequest(servicePrefs, params, services, callback, errorhandler);
            }
        }
    } else {
        doServiceRequest(servicePrefs, params, services, callback, errorhandler);
    }
}

function getServicePrefsForNonConnectorDoc () {
    var prtcl = document.location.protocol;
    if (prtcl.match(/file/)) {
        // This is documentation served off of the file system. We will need a request handler in place to communicate with the help system.
        return ['requesthandler'];
    } else if (prtcl.match(/https?/)) {
        // Web documentation. Use a web service as the first choice, and a messagechannel as the backup.
        return ['webservice', 'messagechannel'];
    } else {
        return [];
    }
}

function doServiceRequest (servicePrefs, params, services, callback, errorhandler) {
    for (var i = 0; i < servicePrefs.length; i++) {
        var svc = servicePrefs[i];
        if (services[svc]) {
            // TODO: It would be great to detect errors and continue falling back.
            switch (svc) {
                case 'messagechannel' :
                    var channel = services[svc];
                    callMessageService(channel, params, callback);
                    return;
                case 'webservice' :
                    var url = services.webservice;
                    var qs = $.param(params);
                    if (qs && qs.length > 0) {
                        url += url.indexOf('?') > 0 ? '&' : '?';
                        url += qs;
                    }
                    var jqxhr = $.get(url);
                    jqxhr.done(callback);
                    if (errorhandler) {
                        jqxhr.fail(errorhandler);
                    }
                    return;
                case 'requesthandler' :
                    var requestHandlerUrl = services.requesthandler + '?' + $.param(params);
                    document.location = requestHandlerUrl;
                    return;
            }
        }
    }
}

function callMessageService (channel, data, callback) {
    window.initDeferred.done(function () {
        window.helpService.callMessageService(channel, data, callback);
    });
}

function isFromMatlabOnline () {
    var cookieRegexp = /MW_Doc_Template="?([^;"]*)/;
    var cookies = document.cookie;
    var matches = cookieRegexp.exec(cookies);
    if (matches != null && matches.length > 0) {
        var docCookie = matches[1];
        var parts = docCookie.split(/\|\|/);
        if (parts[0].indexOf('ONLINE') !== -1) {
            return true;
        }
    }
    return false;
}

if (true) {
    exports.requestHelpService = requestHelpService;
    exports.isFromMatlabOnline = isFromMatlabOnline;
    exports.isMatlabColonLink = isMatlabColonLink;
    exports.handleMatlabColonLink = handleMatlabColonLink;
    exports.setupFinished = setupFinished;
    exports.getSelectedUrl = getSelectedUrl;
    exports.getSessionStorageItem = getSessionStorageItem;
    exports.isSessionStorageItem = isSessionStorageItem;
    exports.handleContextMenu = handleContextMenu;
    exports.isConnectorUrl = isConnectorUrl;
    exports.isWebDocUrl = isWebDocUrl;
    exports.helpserviceIframePostMessage = helpserviceIframePostMessage;
}


/***/ })
/******/ ])));