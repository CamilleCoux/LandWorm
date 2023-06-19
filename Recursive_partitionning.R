###############################################
###############################################
###############################################


SBT_fusion_error_comptage_obs

#SCRIPT 1
model = rpart(MR_EPA ~ Div_GF + AD + JV + Nbr_VDT, data = SBT_fusion_error_comptage_obs, method = 'anova')
rpart.plot(model)


#SCRIPT 2
# Certains normalisent/réduisent leurs données en amont, c'est nécéssaire ?
#Build the initial regression tree
tree <- rpart(MR_EPA ~ Div_GF + AD + JV + Nbr_VDT, data=SBT_fusion_error_comptage_obs, control=rpart.control(minsplit=5,cp=0))
#construit un arbre en continuant les découpages dans les feuilles qui contiennent au moins 5 observations (paramètre minsplit) et sans contrainte sur la qualité du découpage (paramètre cp mis à 0). L'arbre construit de cette façon est assez volumineux et contient XX? feuilles.

?rpart
#Obtenir le bon niveau de simplification => KESAKO ?
plotcp(tree) #Graphique => KESAKO ? ici 13% d'erreur de référence ??
printcp(tree) #Tableau => KESAKO ?



#Simplification
# On choisit en général la complexité qui minimise l'erreur estimée, soit ici 2 feuilles. Certains paramètre à 0.0001
treeSimple <- prune(tree,cp=0.01750468910) #est ce que c'est la même chose que cp = best ?
treeOptimal <- prune(tree,cp=tree$cptable[which.min(tree$cptable[,4]),1])

#Représentation graphique
prp(treeOptimal,extra=1)

#Evaluation des performances => Inutilisable / pas la question ???
table(SBT_fusion_error_comptage_obs$MR_EPA, predict(treeOptimal, SBT_fusion_error_comptage_obs, type="class"))


tree <- rpart(MR_EPI ~ Div_GF + AD + JV + Nbr_VDT, data=SBT_fusion_error_comptage_obs, control=rpart.control(cp=.0001))
printcp(tree)
#Prune the tree
#identify best cp value to use
best <- tree$cptable[which.min(tree$cptable[,"xerror"]),"CP"]
#produce a pruned tree based on the best cp value
pruned_tree <- prune(tree, cp=best)
#plot the pruned tree
prp(pruned_tree,
    faclen=1, #use full names for factor labels
    extra=1, #display number of obs. for each terminal node
    roundint=F, #don't round to integers in output
    digits=5) #display 5 decimal places in output
x11()
