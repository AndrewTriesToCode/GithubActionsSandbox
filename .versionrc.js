const tracker = {
    filename: 'Directory.Build.props',
    updater: {
        readVersion: function (contents) {
            const nr = /<Version>(.+)<\/Version>/.exec(contents);
            return nr[1];
        },

        writeVersion: function (contents, version) {
            return contents.replace(/(<Version>)(.+)(<\/Version>)/, "$1"+version+"$3")
        }
    }
}

module.exports = {
    bumpFiles: [tracker],
    packageFiles: [tracker]
}