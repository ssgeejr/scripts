#!/usr/bin/env python
import urllib2, argparse, json
defaultRegistryPort="80"
 
## Parse command line options
parser = argparse.ArgumentParser()
parser.add_argument("registry", help="Docker Registry host")
parser.add_argument("--port", "-p", help="Docker Registry port, default "+defaultRegistryPort,
                    default=defaultRegistryPort)
args = parser.parse_args()

class registry(object):

    def __init__(self,server,port=80):
        self.server=server
        self.port=port

    def baseUrl(self):
        return "http://"+self.server+":"+self.port+"/v2/"

    def catalogUrl(self):
        return self.baseUrl()+"_catalog"

    def tagUrl(self,image):
        return self.baseUrl()+image+"/tags/list"

    def imageList(self):
        images=[]
        catJson=urllib2.urlopen(self.catalogUrl())
        catDict=json.loads(catJson.read())
        for image in catDict['repositories']:
            images.append(image)
        return images

    def tagList(self, image):
        tags=[]
        tagJson=urllib2.urlopen(self.tagUrl(image))
        tagDict=json.loads(tagJson.read())
        for tag in tagDict['tags']:
            tags.append(tag)
        return tags

    def manifest(self, image, tag='latest'):
        manifestUrl=self.baseUrl()+image+"/manifests/"+tag
        manJson=urllib2.urlopen(manifestUrl)
        manDict=json.loads(manJson.read())
        return manDict

    def labels(self, image, tag='latest'):
        labels=[]
        manifest=self.manifest(image=image,tag=tag)
        return

reg=registry(server=args.registry,port=args.port)
for image in reg.imageList():
    for tag in reg.tagList(image):
        print image+":"+tag
