var exportSprites = function(sprites, locationPrefix)
{
    var result = {};
    for (var i = 0; i < sprites.length; i++)
    {
        var s = sprites[i];
        var frame = {
            x: s.frameRect.x,
            y: s.frameRect.y,
            w: s.frameRect.width,
            h: s.frameRect.height
        };
        var spriteName = locationPrefix + s.trimmedName;
        result[spriteName] = {
            frame: frame,
            rotated: s.rotated,
            trimmed: s.trimmed,
            spriteSourceSize: frame,
            sourceSize: frame
        };
    }
    return result;
};

var generateRelatedMultiPacks = function(root, currentTextureName)
{
    var relatedPacks = [];
    var textures = root.allResults[root.variantIndex].textures;
    for (var i = 0; i < textures.length; i++)
    {
        var textureName = textures[i].fullName;
        if (textureName !== currentTextureName)
        {
            relatedPacks.push(textureName + ".json");
        }
    }
    return relatedPacks;
};

var exportData = function(root)
{
    var settings = root.settings;
    var variantParams = root.variantParams;
    var locationPrefix = root.exporterProperties.location_prefix || '';
    var currentTexture = root.allResults[root.variantIndex].textures[root.multiPackIndex];
    var currentTextureName = currentTexture.fullName;
    var doc = {
        frames: exportSprites(currentTexture.allSprites, locationPrefix),
        meta: {
            app: "https://www.codeandweb.com/texturepacker",
            version: "1.0",
            image: currentTextureName,
            format: settings.outputFormat,
            size: {
                w: currentTexture.size.width,
                h: currentTexture.size.height
            },
            scale: variantParams.scale.toString(),
            related_multi_packs: generateRelatedMultiPacks(root, currentTextureName),
            smartupdate: root.smartUpdateKey
        }
    };
    return JSON.stringify(doc, null, "\t");
};

exportData.filterName = "exportData";
Library.addFilter("exportData");