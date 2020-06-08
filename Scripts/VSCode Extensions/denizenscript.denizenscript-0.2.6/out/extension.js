"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const languageClient = require("vscode-languageclient");
const path = require("path");
const fs = require("fs");
const util_1 = require("util");
const languageServerPath = "server/DenizenLangServer.dll";
const configuration = vscode.workspace.getConfiguration();
function activateLanguageServer(context) {
    let pathFile = context.asAbsolutePath(languageServerPath);
    if (!fs.existsSync(pathFile)) {
        return;
    }
    let pathDir = path.dirname(pathFile);
    let serverOptions = {
        run: { command: "dotnet", args: [pathFile], options: { cwd: pathDir } },
        debug: { command: "dotnet", args: [pathFile, "--debug"], options: { cwd: pathDir } }
    };
    let clientOptions = {
        documentSelector: ["denizenscript"],
        synchronize: {
            configurationSection: "DenizenLangServer",
        },
    };
    let client = new languageClient.LanguageClient("DenizenLangServer", "Denizen Language Server", serverOptions, clientOptions);
    let disposable = client.start();
    context.subscriptions.push(disposable);
}
const highlightDecors = {};
function colorSet(name, incolor) {
    const colorSplit = incolor.split('\|');
    let resultColor = { color: colorSplit[0] };
    for (const i in colorSplit) {
        const subValueSplit = colorSplit[i].split('=', 2);
        const subValueSetting = subValueSplit[0];
        if (subValueSetting == "style") {
            resultColor.fontStyle = subValueSplit[1];
        }
        else if (subValueSetting == "background") {
            resultColor.backgroundColor = subValueSplit[1];
        }
    }
    highlightDecors[name] = vscode.window.createTextEditorDecorationType(resultColor);
}
const colorTypes = [
    "comment_header", "comment_normal", "comment_code", 
    "comment_1", "comment_2", "comment_3", "comment_4", "comment_5", "comment_6",
    "key", "key_inline", "command", "quote_double", "quote_single",
    "tag", "tag_dot", "tag_param", "bad_space", "colons", "space", "normal"
];
function activateHighlighter(context) {
    for (const i in colorTypes) {
        let str = configuration.get("denizenscript.theme_colors." + colorTypes[i]);
        if (util_1.isUndefined(str)) {
            console.log("Missing color config for " + colorTypes[i]);
            continue;
        }
        colorSet(colorTypes[i], str);
    }
}
let refreshTimer = undefined;
function refreshDecor() {
    refreshTimer = undefined;
    for (const editor of vscode.window.visibleTextEditors) {
        const uri = editor.document.uri.toString();
        if (!uri.endsWith(".dsc")) {
            continue;
        }
        decorateFullFile(editor);
    }
}
function addDecor(decorations, type, lineNumber, startChar, endChar) {
    decorations[type].push(new vscode.Range(new vscode.Position(lineNumber, startChar), new vscode.Position(lineNumber, endChar)));
}
function decorateTag(tag, start, lineNumber, decorations) {
    const len = tag.length;
    let inTagCounter = 0;
    let tagStart = 0;
    let inTagParamCounter = 0;
    let defaultDecor = "tag";
    let lastDecor = -1; // Color the < too.
    for (let i = 0; i < len; i++) {
        const c = tag.charAt(i);
        if (c == '<') {
            inTagCounter++;
            if (inTagCounter == 1) {
                addDecor(decorations, defaultDecor, lineNumber, start + lastDecor, start + i);
                lastDecor = i;
                defaultDecor = "tag";
                tagStart = i;
            }
        }
        else if (c == '>' && inTagCounter > 0) {
            inTagCounter--;
            if (inTagCounter == 0) {
                decorateTag(tag.substring(tagStart + 1, i), start + tagStart + 1, lineNumber, decorations);
                addDecor(decorations, "tag", lineNumber, start + i, start + i + 1);
                defaultDecor = inTagParamCounter > 0 ? "tag_param" : "tag";
                lastDecor = i + 1;
            }
        }
        else if (c == '[' && inTagCounter == 0) {
            inTagParamCounter++;
            if (inTagParamCounter == 1) {
                addDecor(decorations, defaultDecor, lineNumber, start + lastDecor, start + i);
                lastDecor = i;
                defaultDecor = "tag_param";
            }
        }
        else if (c == ']' && inTagCounter == 0) {
            inTagParamCounter--;
            if (inTagParamCounter == 0) {
                addDecor(decorations, defaultDecor, lineNumber, start + lastDecor, start + i + 1);
                defaultDecor = "tag";
                lastDecor = i + 1;
            }
        }
        else if (c == '.' && inTagParamCounter == 0) {
            addDecor(decorations, defaultDecor, lineNumber, start + lastDecor, start + i);
            lastDecor = i + 1;
            addDecor(decorations, "tag_dot", lineNumber, start + i, start + i + 1);
        }
        else if (c == ' ' && inTagCounter == 0) {
            addDecor(decorations, defaultDecor, lineNumber, start + lastDecor, start + i);
            addDecor(decorations, "space", lineNumber, start + i, start + i + 1);
            lastDecor = i + 1;
        }
    }
    if (lastDecor < len) {
        addDecor(decorations, defaultDecor, lineNumber, start + lastDecor, start + len);
    }
}
const ifOperators = ["<", ">", "<=", ">=", "==", "!=", "||", "&&", "(", ")"];
function checkIfHasTagEnd(arg, canQuote) {
    const len = arg.length;
    let quoted = false;
    let quoteMode = 'x';
    for (let i = 0; i < len; i++) {
        const c = arg.charAt(i);
        if (canQuote && (c == '"' || c == '\'')) {
            if (quoted && c == quoteMode) {
                quoted = false;
            }
            else if (!quoted) {
                quoted = true;
                quoteMode = c;
            }
        }
        else if (c == '>') {
            return true;
        }
        else if (c == ' ' && !quoted) {
            return false;
        }
    }
    return false;
}
function decorateArg(arg, start, lineNumber, decorations, canQuote) {
    const len = arg.length;
    let quoted = false;
    let quoteMode = 'x';
    let inTagCounter = 0;
    let tagStart = 0;
    let defaultDecor = "normal";
    let lastDecor = 0;
    let hasTagEnd = checkIfHasTagEnd(arg, canQuote);
    for (let i = 0; i < len; i++) {
        const c = arg.charAt(i);
        if (canQuote && (c == '"' || c == '\'')) {
            if (quoted && c == quoteMode) {
                addDecor(decorations, defaultDecor, lineNumber, start + lastDecor, start + i + 1);
                lastDecor = i + 1;
                defaultDecor = "normal";
                quoted = false;
            }
            else if (!quoted) {
                addDecor(decorations, defaultDecor, lineNumber, start + lastDecor, start + i);
                lastDecor = i;
                quoted = true;
                defaultDecor = c == '"' ? "quote_double" : "quote_single";
                quoteMode = c;
            }
        }
        else if (hasTagEnd && c == '<' && i + 1 < len && arg.charAt(i + 1) != '-') {
            inTagCounter++;
            if (inTagCounter == 1) {
                addDecor(decorations, defaultDecor, lineNumber, start + lastDecor, start + i);
                lastDecor = i;
                tagStart = i;
                defaultDecor = "tag";
            }
        }
        else if (hasTagEnd && c == '>' && inTagCounter > 0) {
            inTagCounter--;
            if (inTagCounter == 0) {
                decorateTag(arg.substring(tagStart + 1, i), start + tagStart + 1, lineNumber, decorations);
                addDecor(decorations, "tag", lineNumber, start + i, start + i + 1);
                defaultDecor = quoted ? (quoteMode == '"' ? "quote_double" : "quote_single") : "normal";
                lastDecor = i + 1;
            }
        }
        else if (c == ' ' && (!quoted || inTagCounter == 0)) {
            hasTagEnd = checkIfHasTagEnd(arg.substring(i + 1), canQuote);
            addDecor(decorations, defaultDecor, lineNumber, start + lastDecor, start + i);
            addDecor(decorations, "space", lineNumber, start + i, start + i + 1);
            lastDecor = i + 1;
            if (!quoted) {
                inTagCounter = 0;
                defaultDecor = "normal";
            }
            const nextArg = arg.includes(" ", i + 1) ? arg.substring(i + 1, arg.indexOf(" ", i + 1)) : arg.substring(i + 1);
            if (ifOperators.includes(nextArg)) {
                addDecor(decorations, "colons", lineNumber, start + i + 1, start + i + 1 + nextArg.length);
                i += nextArg.length;
                lastDecor = i;
            }
        }
    }
    if (lastDecor < len) {
        addDecor(decorations, defaultDecor, lineNumber, start + lastDecor, start + len);
    }
}
function decorateComment(line, lineNumber, decorType, decorations) {
    decorateSpaceable(line, 0, lineNumber, decorType, decorations);
}
function decorateSpaceable(line, preLength, lineNumber, decorType, decorations) {
    const len = line.length;
    let lastDecor = 0;
    for (let i = 0; i < len; i++) {
        const c = line.charAt(i);
        if (c == ' ') {
            addDecor(decorations, decorType, lineNumber, preLength + lastDecor, preLength + i);
            addDecor(decorations, "space", lineNumber, preLength + i, preLength + i + 1);
            lastDecor = i + 1;
        }
    }
    if (lastDecor < len) {
        addDecor(decorations, decorType, lineNumber, preLength + lastDecor, preLength + len);
    }
}
function decorateLine(line, lineNumber, decorations) {
    if (line.endsWith("\r")) {
        line = line.substring(0, line.length - 1);
    }
    const trimmedEnd = line.trimRight();
    let trimmed = trimmedEnd.trimLeft();
    if (trimmed.length == 0) {
        return;
    }
    if (trimmedEnd.length != line.length) {
        addDecor(decorations, "bad_space", lineNumber, trimmedEnd.length, line.length);
    }
    const preSpaces = trimmedEnd.length - trimmed.length;
    if (trimmed.startsWith("#")) {
        const afterComment = trimmed.substring(1).trim();
        if (afterComment.startsWith("@") || afterComment.startsWith("_")
            || afterComment.startsWith("/")) {
            decorateComment(line, lineNumber, "comment_header", decorations);
        }
        else if (afterComment.startsWith("-")) {
            decorateComment(line, lineNumber, "comment_code", decorations);
        }
        else if (afterComment.startsWith("=")) {
            decorateComment(line, lineNumber, "comment_1", decorations);
        }
        else if (afterComment.startsWith("$")) {
            decorateComment(line, lineNumber, "comment_2", decorations);
        }
        else if (afterComment.startsWith("%")) {
            decorateComment(line, lineNumber, "comment_3", decorations);
        }
        else if (afterComment.startsWith("^")) {
            decorateComment(line, lineNumber, "comment_4", decorations);
        }
        else if (afterComment.startsWith("|")) {
            decorateComment(line, lineNumber, "comment_5", decorations);
        }
        else if (afterComment.startsWith("+")) {
            decorateComment(line, lineNumber, "comment_6", decorations);
        }
        else if (afterComment.startsWith("#")) {
            decorateComment(line, lineNumber, "comment_normal", decorations);
        }
        else {
            decorateComment(line, lineNumber, "comment_normal", decorations);
        }
    }
    else if (trimmed.startsWith("-")) {
        addDecor(decorations, "normal", lineNumber, preSpaces, preSpaces + 1);
        if (trimmed.endsWith(":")) {
            addDecor(decorations, "colons", lineNumber, preSpaces + trimmed.length - 1, preSpaces + trimmed.length);
            trimmed = trimmed.substring(0, trimmed.length - 1);
        }
        let afterDash = trimmed.substring(1);
        const commandEnd = afterDash.indexOf(' ', 1) + 1;
        const endIndexCleaned = commandEnd == 0 ? preSpaces + trimmed.length : (preSpaces + commandEnd);
        const commandText = commandEnd == 0 ? afterDash : afterDash.substring(0, commandEnd);
        if (!afterDash.startsWith(" ")) {
            addDecor(decorations, "bad_space", lineNumber, preSpaces + 1, endIndexCleaned);
            decorateArg(trimmed.substring(commandEnd), preSpaces + commandEnd, lineNumber, decorations, false);
        }
        else {
            afterDash = afterDash.substring(1);
            if (commandText.includes("'") || commandText.includes("\"") || commandText.includes("[")) {
                decorateArg(trimmed.substring(2), preSpaces + 2, lineNumber, decorations, false);
            }
            else {
                addDecor(decorations, "command", lineNumber, preSpaces + 2, endIndexCleaned);
                if (commandEnd > 0) {
                    decorateArg(trimmed.substring(commandEnd), preSpaces + commandEnd, lineNumber, decorations, true);
                }
            }
        }
    }
    else if (trimmed.endsWith(":")) {
        decorateSpaceable(trimmed.substring(0, trimmed.length - 1), preSpaces, lineNumber, "key", decorations);
        addDecor(decorations, "colons", lineNumber, trimmedEnd.length - 1, trimmedEnd.length);
    }
    else if (trimmed.includes(":")) {
        const colonIndex = line.indexOf(':');
        decorateSpaceable(trimmed.substring(0, colonIndex - preSpaces), preSpaces, lineNumber, "key", decorations);
        addDecor(decorations, "colons", lineNumber, colonIndex, colonIndex + 1);
        decorateArg(trimmed.substring(colonIndex - preSpaces + 1), colonIndex + 1, lineNumber, decorations, false);
    }
    else {
        addDecor(decorations, "bad_space", lineNumber, preSpaces, line.length);
    }
}
function decorateFullFile(editor) {
    let decorations = {};
    for (const c in highlightDecors) {
        decorations[c] = [];
    }
    const fullText = editor.document.getText();
    const splitText = fullText.split('\n');
    const totalLines = splitText.length;
    for (let i = 0; i < totalLines; i++) {
        decorateLine(splitText[i], i, decorations);
    }
    for (const c in decorations) {
        editor.setDecorations(highlightDecors[c], decorations[c]);
    }
}
function scheduleRefresh() {
    if (refreshTimer) {
        return;
    }
    refreshTimer = setTimeout(refreshDecor, 50);
}
function activate(context) {
    activateLanguageServer(context);
    activateHighlighter(context);
    vscode.workspace.onDidOpenTextDocument(doc => {
        if (doc.uri.toString().endsWith(".dsc")) {
            scheduleRefresh();
        }
    }, null, context.subscriptions);
    vscode.workspace.onDidChangeTextDocument(event => {
        if (event.document.uri.toString().endsWith(".dsc")) {
            scheduleRefresh();
        }
    }, null, context.subscriptions);
    vscode.window.onDidChangeVisibleTextEditors(editors => {
        scheduleRefresh();
    }, null, context.subscriptions);
    scheduleRefresh();
    console.log('Denizen extension has been activated');
}
exports.activate = activate;
function deactivate() {
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map