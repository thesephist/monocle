const SourceFile = '/tmp/pocket.json'
const DestFile = '/tmp/pocket-full-text.json'

const { writeFileSync } = require('fs');

const { Readability } = require('@mozilla/readability');
const { JSDOM } = require('jsdom');
const fetch = require('node-fetch');

const PocketDocs = require(SourceFile);
const PartialDestFile = require(DestFile);

console.log(`Found ${PocketDocs.length} docs, downloading and parsing using @mozilla/readability.`);
console.log(`Partial cache contained ${PartialDestFile.length} docs.`);

(async function() {
    // Map of href to doc type
    const FullTextDocs = {};
    for (const doc of PartialDestFile) {
        FullTextDocs[doc.href] = doc;
    }

    let i = 0;
    for (const { title, href } of PocketDocs) {
        // To make this process interruptible, we write a partial progress
        // cache every 25 items.
        if (i % 25 === 0) {
            const docsSoFar = Object.values(FullTextDocs);
            console.log(`Writing partial cache with ${docsSoFar.length} docs...`);
            writeFileSync(DestFile, JSON.stringify(docsSoFar), 'utf8');
        }

        // Skip attempting to parse media files
        if (href.endsWith('.png') || href.endsWith('.jpg') ||
            href.endsWith('.gif') || href.endsWith('.mp4') ||
            href.endsWith('.mov') || href.endsWith('.pdf')) {
            FullTextDocs[href] = {
                title: title,
                content: href,
                href: href,
            }

            i ++;
            continue;
        }

        const alreadyParsed = FullTextDocs[href];
        if (alreadyParsed) {
            console.log(`Using ${href} found in partial cache...`);
            i ++;
            continue;
        }

        console.log(`Parsing (${i + 1}/${PocketDocs.length}) ${href}...`);

        // For a number of reasons, either JSDOM or Readability may throw if it
        // fails to parse the page. In those cases, we bail and just keep the
        // title + href.
        try {
            // Download the HTML source
            const html = await fetch(href).then(resp => resp.text());

            // Create a mock document to work with Readability.js
            const doc = new JSDOM(html, { url: href });

            // Parse with Readability.
            const reader = new Readability(doc.window.document, {
                // Default is (at time of writing) 500 chars. We want to consider
                // shorter documents valid, too, for purpose of Monocle search.
                charThreshold: 20,
            });

            const page = reader.parse();
            if (!page) {
                FullTextDocs[href] = {
                    title: title,
                    content: href,
                    href: href,
                }

                i ++;
                continue;
            }

            const {
                title: readabilityTitle,
                textContent,
                siteName,
            } = page;

            // If the page is longer than ~10k words, don't cache or index.
            // It's not worth it.
            if (textContent.length > 5 * 10000) {
                FullTextDocs[href] = {
                    title: title,
                    content: href,
                    href: href,
                }

                i ++;
                continue;
            }

            FullTextDocs[href] = {
                title: siteName ? `${readabilityTitle} | ${siteName}` : readabilityTitle,
                content: textContent || href,
                href: href,
            }
        } catch (e) {
            console.log(`Error during parse of ${href} (${e})... continuing.`);
            FullTextDocs[href] = {
                title: title,
                content: href,
                href: href,
            }
        }

        i ++;
    }

    writeFileSync(DestFile, JSON.stringify(Object.values(FullTextDocs)), 'utf8');
    console.log('done!');
})();

