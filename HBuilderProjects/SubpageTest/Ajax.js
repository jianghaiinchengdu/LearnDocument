/**
 * mui ajax
 * @param {type} $
 * @returns {undefined}
 */
(function($, window, undefined) {

	var jsonType = 'application/json';
	var htmlType = 'text/html';
	var rscript = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
	var scriptTypeRE = /^(?:text|application)\/javascript/i;
	var xmlTypeRE = /^(?:text|application)\/xml/i;
	var blankRE = /^\s*$/;

	$.ajaxSettings = {
		type: 'GET',
		beforeSend: $.noop,
		success: $.noop,
		error: $.noop,
		complete: $.noop,
		context: null,
		xhr: function(protocol) {
			return new window.XMLHttpRequest();
		},
		accepts: {
			script: 'text/javascript, application/javascript, application/x-javascript',
			json: jsonType,
			xml: 'application/xml, text/xml',
			html: htmlType,
			text: 'text/plain'
		},
		timeout: 0,
		processData: true,
		cache: true
	};
	var ajaxBeforeSend = function(xhr, settings) {
		var context = settings.context
		if (settings.beforeSend.call(context, xhr, settings) === false) {
			return false;
		}
	};
	var ajaxSuccess = function(data, xhr, settings) {
		settings.success.call(settings.context, data, 'success', xhr);
		ajaxComplete('success', xhr, settings);
	};
	// type: "timeout", "error", "abort", "parsererror"
	var ajaxError = function(error, type, xhr, settings) {
		settings.error.call(settings.context, xhr, type, error);
		ajaxComplete(type, xhr, settings);
	};
	// status: "success", "notmodified", "error", "timeout", "abort", "parsererror"
	var ajaxComplete = function(status, xhr, settings) {
		settings.complete.call(settings.context, xhr, status);
	};

	var serialize = function(params, obj, traditional, scope) {
		var type, array = $.isArray(obj),
			hash = $.isPlainObject(obj);
		$.each(obj, function(key, value) {
			type = $.type(value);
			if (scope) {
				key = traditional ? scope :
					scope + '[' + (hash || type === 'object' || type === 'array' ? key : '') + ']';
			}
			// handle data in serializeArray() format
			if (!scope && array) {
				params.add(value.name, value.value);
			}
			// recurse into nested objects
			else if (type === "array" || (!traditional && type === "object")) {
				serialize(params, value, traditional, key);
			} else {
				params.add(key, value);
			}
		});
	};
	var serializeData = function(options) {
		if (options.processData && options.data && typeof options.data !== "string") {
			options.data = $.param(options.data, options.traditional);
		}
		if (options.data && (!options.type || options.type.toUpperCase() === 'GET')) {
			options.url = appendQuery(options.url, options.data);
			options.data = undefined;
		}
	};
	var appendQuery = function(url, query) {
		if (query === '') {
			return url;
		}
		return (url + '&' + query).replace(/[&?]{1,2}/, '?');
	};
	var mimeToDataType = function(mime) {
		if (mime) {
			mime = mime.split(';', 2)[0];
		}
		return mime && (mime === htmlType ? 'html' :
			mime === jsonType ? 'json' :
			scriptTypeRE.test(mime) ? 'script' :
			xmlTypeRE.test(mime) && 'xml') || 'text';
	};
	var parseArguments = function(url, data, success, dataType) {
		if ($.isFunction(data)) {
			dataType = success, success = data, data = undefined;
		}
		if (!$.isFunction(success)) {
			dataType = success, success = undefined;
		}
		return {
			url: url,
			data: data,
			success: success,
			dataType: dataType
		};
	};
	$.ajax = function(url, options) {
		if (typeof url === "object") {
			options = url;
			url = undefined;
		}
		var settings = options || {};
		settings.url = url || settings.url;
		for (var key in $.ajaxSettings) {
			if (settings[key] === undefined) {
				settings[key] = $.ajaxSettings[key];
			}
		}
		serializeData(settings);
		var dataType = settings.dataType;

		if (settings.cache === false || ((!options || options.cache !== true) && ('script' === dataType))) {
			settings.url = appendQuery(settings.url, '_=' + $.now());
		}
		var mime = settings.accepts[dataType && dataType.toLowerCase()];
		var headers = {};
		var setHeader = function(name, value) {
			headers[name.toLowerCase()] = [name, value];
		};
		var protocol = /^([\w-]+:)\/\//.test(settings.url) ? RegExp.$1 : window.location.protocol;
		var xhr = settings.xhr(settings);
		var nativeSetHeader = xhr.setRequestHeader;
		var abortTimeout;

		setHeader('X-Requested-With', 'XMLHttpRequest');
		setHeader('Accept', mime || '*/*');
		if (!!(mime = settings.mimeType || mime)) {
			if (mime.indexOf(',') > -1) {
				mime = mime.split(',', 2)[0];
			}
			xhr.overrideMimeType && xhr.overrideMimeType(mime);
		}
		if (settings.contentType || (settings.contentType !== false && settings.data && settings.type.toUpperCase() !== 'GET')) {
			setHeader('Content-Type', settings.contentType || 'application/x-www-form-urlencoded');
		}
		if (settings.headers) {
			for (var name in settings.headers)
				setHeader(name, settings.headers[name]);
		}
		xhr.setRequestHeader = setHeader;

		xhr.onreadystatechange = function() {
			if (xhr.readyState === 4) {
				xhr.onreadystatechange = $.noop;
				clearTimeout(abortTimeout);
				var result, error = false;
				var isLocal = protocol === 'file:';
				if ((xhr.status >= 200 && xhr.status < 300) || xhr.status === 304 || (xhr.status === 0 && isLocal && xhr.responseText)) {
					dataType = dataType || mimeToDataType(settings.mimeType || xhr.getResponseHeader('content-type'));
					result = xhr.responseText;
					try {
						// http://perfectionkills.com/global-eval-what-are-the-options/
						if (dataType === 'script') {
							(1, eval)(result);
						} else if (dataType === 'xml') {
							result = xhr.responseXML;
						} else if (dataType === 'json') {
							result = blankRE.test(result) ? null : $.parseJSON(result);
						}
					} catch (e) {
						error = e;
					}

					if (error) {
						ajaxError(error, 'parsererror', xhr, settings);
					} else {
						ajaxSuccess(result, xhr, settings);
					}
				} else {
					var status = xhr.status ? 'error' : 'abort';
					var statusText = xhr.statusText || null;
					if (isLocal) {
						status = 'error';
						statusText = '404';
					}
					ajaxError(statusText, status, xhr, settings);
				}
			}
		};
		if (ajaxBeforeSend(xhr, settings) === false) {
			xhr.abort();
			ajaxError(null, 'abort', xhr, settings);
			return xhr;
		}

		if (settings.xhrFields) {
			for (var name in settings.xhrFields) {
				xhr[name] = settings.xhrFields[name];
			}
		}

		var async = 'async' in settings ? settings.async : true;

		xhr.open(settings.type.toUpperCase(), settings.url, async, settings.username, settings.password);

		for (var name in headers) {
			nativeSetHeader.apply(xhr, headers[name]);
		}
		if (settings.timeout > 0) {
			abortTimeout = setTimeout(function() {
				xhr.onreadystatechange = $.noop;
				xhr.abort();
				ajaxError(null, 'timeout', xhr, settings);
			}, settings.timeout);
		}
		xhr.send(settings.data ? settings.data : null);
		return xhr;
	};


	$.param = function(obj, traditional) {
		var params = [];
		params.add = function(k, v) {
			this.push(encodeURIComponent(k) + '=' + encodeURIComponent(v));
		};
		serialize(params, obj, traditional);
		return params.join('&').replace(/%20/g, '+');
	};
	$.get = function( /* url, data, success, dataType */ ) {
		return $.ajax(parseArguments.apply(null, arguments));
	};

	$.post = function( /* url, data, success, dataType */ ) {
		var options = parseArguments.apply(null, arguments);
		options.type = 'POST';
		return $.ajax(options);
	};

	$.getJSON = function( /* url, data, success */ ) {
		var options = parseArguments.apply(null, arguments);
		options.dataType = 'json';
		return $.ajax(options);
	};

	$.fn.load = function(url, data, success) {
		if (!this.length)
			return this;
		var self = this,
			parts = url.split(/\s/),
			selector,
			options = parseArguments(url, data, success),
			callback = options.success;
		if (parts.length > 1)
			options.url = parts[0], selector = parts[1];
		options.success = function(response) {
			if (selector) {
				var div = document.createElement('div');
				div.innerHTML = response.replace(rscript, "");
				var selectorDiv = document.createElement('div');
				var childs = div.querySelectorAll(selector);
				if (childs && childs.length > 0) {
					for (var i = 0, len = childs.length; i < len; i++) {
						selectorDiv.appendChild(childs[i]);
					}
				}
				self[0].innerHTML = selectorDiv.innerHTML;
			} else {
				self[0].innerHTML = response;
			}
			callback && callback.apply(self, arguments);
		};
		$.ajax(options);
		return this;
	};

})(mui, window);
/**
 * 5+ ajax
 */
(function($) {
	var originAnchor = document.createElement('a');
	originAnchor.href = window.location.href;
	$.plusReady(function() {
		$.ajaxSettings = $.extend($.ajaxSettings, {
			xhr: function(settings) {
				if (settings.crossDomain) { //强制使用plus跨域
					return new plus.net.XMLHttpRequest();
				}
				//仅在webview的url为远程文件，且ajax请求的资源不同源下使用plus.net.XMLHttpRequest
				if (originAnchor.protocol !== 'file:') {
					var urlAnchor = document.createElement('a');
					urlAnchor.href = settings.url;
					urlAnchor.href = urlAnchor.href;
					settings.crossDomain = (originAnchor.protocol + '//' + originAnchor.host) !== (urlAnchor.protocol + '//' + urlAnchor.host);
					if (settings.crossDomain) {
						return new plus.net.XMLHttpRequest();
					}
				}
				return new window.XMLHttpRequest();
			}
		});
	});
})(mui);

function(a, b, c) {
		var d = "application/json",
			e = "text/html",
			f = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,
			g = /^(?:text|application)\/javascript/i,
			h = /^(?:text|application)\/xml/i,
			i = /^\s*$/;
		a.ajaxSettings = {
			type: "GET",
			beforeSend: a.noop,
			success: a.noop,
			error: a.noop,
			complete: a.noop,
			context: null,
			xhr: function(a) {
				return new b.XMLHttpRequest
			},
			accepts: {
				script: "text/javascript, application/javascript, application/x-javascript",
				json: d,
				xml: "application/xml, text/xml",
				html: e,
				text: "text/plain"
			},
			timeout: 0,
			processData: !0,
			cache: !0
		};
		var j = function(a, b) {
				var c = b.context;
				return b.beforeSend.call(c, a, b) === !1 ? !1 : void 0
			},
			k = function(a, b, c) {
				c.success.call(c.context, a, "success", b), m("success", b, c)
			},
			l = function(a, b, c, d) {
				d.error.call(d.context, c, b, a), m(b, c, d)
			},
			m = function(a, b, c) {
				c.complete.call(c.context, b, a)
			},
			n = function(b, c, d, e) {
				var f, g = a.isArray(c),
					h = a.isPlainObject(c);
				a.each(c, function(c, i) {
					f = a.type(i), e && (c = d ? e : e + "[" + (h || "object" === f || "array" === f ? c : "") + "]"), !e && g ? b.add(i.name, i.value) : "array" === f || !d && "object" === f ? n(b, i, d, c) : b.add(c, i)
				})
			},
			o = function(b) {
				b.processData && b.data && "string" != typeof b.data && (b.data = a.param(b.data, b.traditional)), !b.data || b.type && "GET" !== b.type.toUpperCase() || (b.url = p(b.url, b.data), b.data = c)
			},
			p = function(a, b) {
				return "" === b ? a : (a + "&" + b).replace(/[&?]{1,2}/, "?")
			},
			q = function(a) {
				return a && (a = a.split(";", 2)[0]), a && (a === e ? "html" : a === d ? "json" : g.test(a) ? "script" : h.test(a) && "xml") || "text"
			},
			r = function(b, d, e, f) {
				return a.isFunction(d) && (f = e, e = d, d = c), a.isFunction(e) || (f = e, e = c), {
					url: b,
					data: d,
					success: e,
					dataType: f
				}
			};
		a.ajax = function(d, e) {
			"object" == typeof d && (e = d, d = c);
			var f = e || {};
			f.url = d || f.url;
			for (var g in a.ajaxSettings) f[g] === c && (f[g] = a.ajaxSettings[g]);
			o(f);
			var h = f.dataType;
			f.cache !== !1 && (e && e.cache === !0 || "script" !== h) || (f.url = p(f.url, "_=" + a.now()));
			var m, n = f.accepts[h && h.toLowerCase()],
				r = {},
				s = function(a, b) {
					r[a.toLowerCase()] = [a, b]
				},
				t = /^([\w-]+:)\/\//.test(f.url) ? RegExp.$1 : b.location.protocol,
				u = f.xhr(f),
				v = u.setRequestHeader;
			if (s("X-Requested-With", "XMLHttpRequest"), s("Accept", n || "*/*"), (n = f.mimeType || n) && (n.indexOf(",") > -1 && (n = n.split(",", 2)[0]), u.overrideMimeType && u.overrideMimeType(n)), (f.contentType || f.contentType !== !1 && f.data && "GET" !== f.type.toUpperCase()) && s("Content-Type", f.contentType || "application/x-www-form-urlencoded"), f.headers)
				for (var w in f.headers) s(w, f.headers[w]);
			if (u.setRequestHeader = s, u.onreadystatechange = function() {
					if (4 === u.readyState) {
						u.onreadystatechange = a.noop, clearTimeout(m);
						var b, c = !1,
							d = "file:" === t;
						if (u.status >= 200 && u.status < 300 || 304 === u.status || 0 === u.status && d && u.responseText) {
							h = h || q(f.mimeType || u.getResponseHeader("content-type")), b = u.responseText;
							try {
								"script" === h ? (1, eval)(b) : "xml" === h ? b = u.responseXML : "json" === h && (b = i.test(b) ? null : a.parseJSON(b))
							} catch (e) {
								c = e
							}
							c ? l(c, "parsererror", u, f) : k(b, u, f)
						} else {
							var g = u.status ? "error" : "abort",
								j = u.statusText || null;
							d && (g = "error", j = "404"), l(j, g, u, f)
						}
					}
				}, j(u, f) === !1) return u.abort(), l(null, "abort", u, f), u;
			if (f.xhrFields)
				for (var w in f.xhrFields) u[w] = f.xhrFields[w];
			var x = "async" in f ? f.async : !0;
			u.open(f.type.toUpperCase(), f.url, x, f.username, f.password);
			for (var w in r) v.apply(u, r[w]);
			return f.timeout > 0 && (m = setTimeout(function() {
				u.onreadystatechange = a.noop, u.abort(), l(null, "timeout", u, f)
			}, f.timeout)), u.send(f.data ? f.data : null), u
		}, a.param = function(a, b) {
			var c = [];
			return c.add = function(a, b) {
				this.push(encodeURIComponent(a) + "=" + encodeURIComponent(b))
			}, n(c, a, b), c.join("&").replace(/%20/g, "+")
		}, a.get = function() {
			return a.ajax(r.apply(null, arguments))
		}, a.post = function() {
			var b = r.apply(null, arguments);
			return b.type = "POST", a.ajax(b)
		}, a.getJSON = function() {
			var b = r.apply(null, arguments);
			return b.dataType = "json", a.ajax(b)
		}, a.fn.load = function(b, c, d) {
			if (!this.length) return this;
			var e, g = this,
				h = b.split(/\s/),
				i = r(b, c, d),
				j = i.success;
			return h.length > 1 && (i.url = h[0], e = h[1]), i.success = function(a) {
				if (e) {
					var b = document.createElement("div");
					b.innerHTML = a.replace(f, "");
					var c = document.createElement("div"),
						d = b.querySelectorAll(e);
					if (d && d.length > 0)
						for (var h = 0, i = d.length; i > h; h++) c.appendChild(d[h]);
					g[0].innerHTML = c.innerHTML
				} else g[0].innerHTML = a;
				j && j.apply(g, arguments)
			}, a.ajax(i), this
		}
	}(mui, window),
	function(a) {
		var b = document.createElement("a");
		b.href = window.location.href, a.plusReady(function() {
			a.ajaxSettings = a.extend(a.ajaxSettings, {
				xhr: function(a) {
					if (a.crossDomain) return new plus.net.XMLHttpRequest;
					if ("file:" !== b.protocol) {
						var c = document.createElement("a");
						if (c.href = a.url, c.href = c.href, a.crossDomain = b.protocol + "//" + b.host != c.protocol + "//" + c.host, a.crossDomain) return new plus.net.XMLHttpRequest
					}
					return new window.XMLHttpRequest
				}
			})
		})
	}(mui),
	