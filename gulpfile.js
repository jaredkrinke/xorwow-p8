const fs = require("fs");
const { src, dest, watch } = require("gulp");
const replace = require("gulp-replace-async");

function build() {
    return src("*.p8")
        .pipe(replace(/#include[ \t]+"([^"]+)"/g, function ([text, fileName], cb) {
            fs.readFile(fileName, function (err, data) {
                cb(err, data);
            });
        }))
        .pipe(dest("output/"));
}

exports.default = build;
exports.watch = function () {
    watch(["*.p8", "*.lua"], exports.default);
};
