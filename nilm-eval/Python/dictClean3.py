def removew(d):
    return   {k.replace(" ", ""): v for k, v in d.iteritems()}