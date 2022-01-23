console.log("Starting script...");
const puppeteer = require('puppeteer');
const mustache = require('mustache')
const fs = require('fs');
const tempFileName = "templates/cache.html";
var config = require('./config.json');

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    // Iterate through languages.
    for (const langFile of config.languageFiles) {

        // Load all template strings for language.
        console.log(`Loading language ${langFile}`);
        var language = require(`./strings/${langFile}.json`);
        var languageTemplateStrings = language.templateStrings;

        // Iterate through screenshot templates.
        const numberOfTemplates = config.numberOfTemplates;
        for (var templateIndex = 1; templateIndex <= numberOfTemplates; templateIndex++) {

            // Load template strings.
            if (templateIndex > languageTemplateStrings.length) {
                console.log(`Warning: ${langFile}.json is missing strings for template ${templateIndex}`);
                continue;
            }
            const localStrings = languageTemplateStrings[templateIndex - 1];

            // Fill template with data.
            const templateData = fs.readFileSync(`templates/${templateIndex}.html`, 'utf-8');
            const templateRendered = mustache.render(templateData, localStrings);

            // Write template to html file.
            await fs.writeFileSync(tempFileName, templateRendered);

            // Iterate through device/output sizes.
            const outputSizes = config.outputSizes;
            for (var outputSizeIndex = 0; outputSizeIndex < outputSizes.length; outputSizeIndex++) {
                const sizeInfo = outputSizes[outputSizeIndex];

                // Set browser window size for device.
                await page.setViewport({
                    width: sizeInfo.width,
                    height: sizeInfo.height,
                    deviceScaleFactor: sizeInfo.scale,
                });

                // Load html file in browser.
                await page.goto(`file://${__dirname}/${tempFileName}`);
                await page.waitForNetworkIdle();

                // Create folder.
                createDirectory(`./output/${langFile}`)
                await page.screenshot({path: `output/${langFile}/${sizeInfo.width}x${sizeInfo.height}_${templateIndex}.png`});

            }
            
        }

        // Delete cache file.
        fs.unlinkSync(tempFileName);

    };


    await browser.close();

})();

function createDirectory(name) {
    if (!fs.existsSync(name)){
        fs.mkdirSync(name);
    }
}
