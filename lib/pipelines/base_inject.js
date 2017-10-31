'use strict';

const _ = require('lodash');
const combiner = require('stream-combiner');
const gulp = require('gulp');
const inject = require('gulp-inject');
const path = require('path');
const series = require('stream-series');

function baseInject(options) {
	const util = options.util;
	const pathDest = options.pathDest;

	const siteData = require(path.join(process.cwd(), pathDest, 'site.json'));

	const bundleSrc =
		options.bundleSrc ||
		util.synthSrc(
			path.join(process.cwd(), pathDest, 'js/bundles/shared.electric.js')
		);
	const vendorSrc = gulp.src(
		path.join(process.cwd(), pathDest, 'vendor/**/*'),
		{
			read: false
		}
	);

	const deployOptions = {
		ignorePath: pathDest
	};

	let url = '';

	if (options.deployOptions.url) {
		url = options.deployOptions.url;
		deployOptions.addRootSlash = false;
		deployOptions.addPrefix = url;
	}

	return combiner(
		inject(series(bundleSrc, vendorSrc), deployOptions),
		inject(gulp.src(path.join(__dirname, '../templates/metal-render.tpl')), {
			starttag: '<!-- inject:metal:js -->',
			transform: function(filePath, file) {
				return _.template(file.contents.toString())({url: url});
			}
		}),
		inject(gulp.src(path.join(__dirname, '../templates/vendor.tpl')), {
			starttag: '<!-- inject:vendor:js -->',
			transform: function(filePath, file) {
				const data = {
					codeMirror: false,
					googleAnalytics: siteData.googleAnalytics
				};

				if (options.codeMirror) {
					data.codeMirror = {
						theme: options.codeMirrorTheme
					};
				}

				return _.template(file.contents.toString())(data);
			}
		})
	);
}

module.exports = baseInject;
