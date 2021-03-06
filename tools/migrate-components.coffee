
yaml = require 'js-yaml'
path = require 'path'
fs = require 'fs'

template = (name, def, all) ->
    out =
        name: name
        description: def.description
        inports: {}
        outports: {}
    out.type = def.type if def.type?
    def.inPorts = all.defaultInPorts if not def.inPorts?
    def.outPorts = all.defaultOutPorts if not def.outPorts?

    for portName, portDef of def.inPorts
        p = portDef
        delete p.id
        p.type = "all"
        p.description = p.description or ""
        out.inports[portName] = p

    for portName, portDef of def.outPorts
        p = portDef
        delete p.id
        p.type = "all"
        p.description = p.description or ""
        out.outports[portName] = p

    ser = yaml.safeDump out

    s = "/* microflo_component yaml"+
    "\n"+ ser +
    "microflo_component */" +
    "\n"
    return s

componentDir = 'microflo/core/components'
inp = require '../microflo/components.json'
for name, def of inp.components
    continue if def['.skip']?

    componentFile = path.join componentDir, name + '.hpp'
    opt =
        encoding: 'utf-8'
    content = fs.readFileSync componentFile, opt
    content = template(name, def, inp) + content
    fs.writeFileSync componentFile, content, opt
    
