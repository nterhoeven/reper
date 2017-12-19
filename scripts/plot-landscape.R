library(ggplot2)

dataClass=read.table('repeat-landscape_by-class.tab', head=T)

g=ggplot(dataClass, aes(class, genomPart.Mbp.))
g+geom_bar(stat="identity")+ylab("genomic part [Mbp]")+theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust=0.5))
ggsave("repeat-landscape_by-class.pdf", device="pdf", width=28, height=21, units="cm")


dataCluster=read.table('repeat-landscape_by-cluster.tab', head=T)

g=ggplot(dataCluster, aes(clstrID,genomPart.Mbp., color=class))
g+geom_point()+xlab("cluster ID")+ylab("genomic part [Mbp]")
ggsave("repeat-landscape_by-cluster.pdf", device="pdf", width=28, height=21, units="cm")
