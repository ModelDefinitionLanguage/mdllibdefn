/*******************************************************************************
 * Copyright (c) 2016 Pfizer Ltd.
 *
 * This file is part of the MDL Library.
 *
 * The MDL Library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * The MDL Library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with The MDL Library.  If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************/
/*
 * generated by Xtext
 */
package eu.ddmore.mdllib.generator

import eu.ddmore.mdllib.mdllib.BlockDefinition
import eu.ddmore.mdllib.mdllib.Library
import eu.ddmore.mdllib.mdllib.ListTypeDefinition
import eu.ddmore.mdllib.mdllib.NamedFuncArgs
import eu.ddmore.mdllib.mdllib.ObjectDefinition
import eu.ddmore.mdllib.mdllib.StatementTypeDefn
import eu.ddmore.mdllib.mdllib.SubListTypeDefinition
import eu.ddmore.mdllib.mdllib.TypeClass
import eu.ddmore.mdllib.mdllib.TypeDefinition
import eu.ddmore.mdllib.mdllib.TypeSpec
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import java.util.Collections
import java.util.Comparator
import eu.ddmore.mdllib.mdllib.ArgumentDefinition
import eu.ddmore.mdllib.mdllib.AttValListMap
import eu.ddmore.mdllib.mdllib.FuncArgumentDefinition
import eu.ddmore.mdllib.mdllib.ListAttributeDefn
import eu.ddmore.mdllib.mdllib.AbstractTypeDefinition
import eu.ddmore.mdllib.mdllib.PropertyReference
import eu.ddmore.mdllib.mdllib.FunctionDefnBody
import eu.ddmore.mdllib.mdllib.MappingTypeDefinition
import eu.ddmore.mdllib.mdllib.AttNameListMap

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MdlLibGenerator implements IGenerator {
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val content = resource.contents.head
		if(content != null){
			fsa.generateFile('mdl_reference.tex', writeDocument(content as Library))
		}
	}
	
	def private String hyperLink(String text, String type)'''
		\hyperref[«type»:«text.protectRefString»]{«text»}
	'''
		
	
	
	def writeDocument(Library it)'''
		\documentclass[a4wide,10pt]{article}
		\usepackage{hyperref}
		
		\title{MDL Reference}
		
		\author{Stuart Moodie and Mike Smith}
		
		\setcounter{tocdepth}{2}
		\setcounter{secnumdepth}{2}
		
		\begin{document}
		
		\maketitle 
		
		
		\tableofcontents
		
		\newpage
		
		«writeObjects»
		
		«writeBlocks»
		
		«writeLists»
		
		«writeSubLists»
		
		«writeFunctions»
		
		«writeTypes»
		
		\end{document}
	'''

	def writeObjects(Library it)'''
		\section{Objects}
		\subsection{Summary}
		%
		«writeLatexTable(#['Name', 'Description'], #['l', 'l'], [
			val retVal = new ArrayList<List<String>>
			for(obj : sort(objectDefns, new Comparator<ObjectDefinition>(){
				
				override compare(ObjectDefinition o1, ObjectDefinition o2) {
					o1.name.compareTo(o2.name)
				}
				
			})){
				retVal.add(#[hyperLink(obj.name, 'obj'), ''])
			}
			retVal
		])»

		\newpage
		«FOR obj : objectDefns»
			«writeObjectContent(obj)»
		«ENDFOR»
	'''
	
	def private getStmtCode(StatementTypeDefn std)
		'''
			«switch(std.stmtType){
				case EQN_DEFN:
					'E'
				case LIST_DEFN:	
					'L'
				case ANON_LIST_STMT:	
					'A'
				case ENUM_DEFN:	
					'E'
				case RV_DEFN:	
					'R'
				case PROP_STMT:	
					'P'
				case TRANS_DEFN:	
					'T'
			}»«IF std.hasRhs»+«ENDIF»
		'''
	
	
	def private String writeStmtTypes(BlockDefinition it)
		'''«FOR st : stmtTypes SEPARATOR ' '»«st.stmtCode»«ENDFOR»
		'''
	
	def writeObjectContent(Library lib, ObjectDefinition od)'''
		\subsection{Object: «od.name»}
		\label{obj:«od.name»}

		\subsubsection{Blocks}
		%
		«writeLatexTable(#['Name', 'Description'], #['l', 'l'],
						[
							val retVal = new ArrayList<List<String>>
							for(cd : lib.containDefns){
								if(cd.parentRef == od){
									for(blkRef : sort(cd.blkRefs, new Comparator<BlockDefinition>(){
										
										override compare(BlockDefinition o1, BlockDefinition o2) {
											o1.name.compareTo(o2.name)
										}
										
									})){
										val row = new ArrayList<String>
										row.add(hyperLink(blkRef.name, 'block'))
										row.add('')
										retVal.add(row)
									}
								}
							}
							retVal
						]
		)»
		
		
«««		«writeLatexTable(#['Name', 'Description', 'Cardinality', 'Num Stmts', 'Stmt Type'],
«««						#['l', 'l', 'c', 'c', 'l'],
«««						[
«««							val retVal = new ArrayList<List<String>>
«««							for(cd : lib.containDefns){
«««								if(cd.parentRef == od){
«««									for(blkRef : cd.blkRefs){
«««										val row = new ArrayList<String>
«««										row.add(blkRef.name)
«««										row.add('')
«««										row.add(printRange(blkRef.minNum, blkRef.maxNum))
«««										row.add(printRange(blkRef.minStmtNum, blkRef.maxStmtNum))
«««										row.add(writeStmtTypes(blkRef))
«««										retVal.add(row)
«««									}
«««								}
«««							}
«««							retVal
«««						]
«««		)»
		
		
		\newpage
	'''
	
	
	def private static <T> sort(List<T> lst, Comparator<T> cmp){
		val retVal = new ArrayList<T>(lst)
		Collections::sort(retVal, cmp)
		retVal
	} 
	
	def writeBlocks(Library it)'''
		\section{Block Definitions}
		«FOR blk : sort(blockDefns, new Comparator<BlockDefinition>(){
			override compare(BlockDefinition o1, BlockDefinition o2) {
				o1.name.compareTo(o2.name)
			}
		})»
			\subsection{«blk.name.protectString»}
			\label{block:«blk.name.protectRefString»}
			«IF !blk.arguments.isEmpty»
				\subsubsection{Arguments}
				
				«writeLatexTable(#['Attribute', 'Type', 'Optional', 'Description'], #['l','l','c', 'l'], [
					val retVal = new ArrayList<List<String>>
					for(arg: sort(blk.arguments, new Comparator<ArgumentDefinition>(){
						override compare(ArgumentDefinition o1, ArgumentDefinition o2) {
							o1.name.compareTo(o2.name)
						}
					})){
						val row = new ArrayList<String>
						row.add(arg.name)
						row.add(arg.argType.writeTypeSpec)
						row.add(if(arg.optional) 'true' else 'false')
						row.add('')
						retVal.add(row)
					}
					retVal
				])»
			«ENDIF»
			\subsubsection{Constraints}
			%
			\begin{description}
				\item[Number of blocks in object] «printRange(blk.minNum, blk.maxNum)»
				\item[Number of statements in block] «printRange(blk.minStmtNum, blk.maxStmtNum)»
				\item[Permitted statement types] «writeStmtTypes(blk)»
			\end{description}

			«IF containDefns.exists[if(parentRef == blk) !blkRefs.isEmpty else false]»
				\subsubsection{Sub-Blocks}
				%
				«writeLatexTable(#['Name', 'Description'], #['l', 'l'],
					[
						val retVal = new ArrayList<List<String>>
						for(cd : containDefns){
							if(cd.parentRef == blk){
								for(blkRef : sort(cd.blkRefs, new Comparator<BlockDefinition>(){
									
									override compare(BlockDefinition o1, BlockDefinition o2) {
										o1.name.compareTo(o2.name)
									}
									
								})){
									val row = new ArrayList<String>
									row.add(hyperLink(blkRef.name, 'block'))
									row.add('')
									retVal.add(row)
								}
							}
						}
						retVal
					]
				)»
			«ENDIF»
			«IF blk.listType != null || !blk.listTypeMappings.isEmpty || !blk.listAttMappings.isEmpty»
				\subsubsection{Lists}
				%
				«writeLatexTable(#['List', 'Key Attribute', 'Key Value'], #['l', 'l', 'l'], [
					val retVal = new ArrayList<List<String>>	
					if(blk.listType != null){
						val row = new ArrayList<String>
						row.add(hyperLink(blk.listType.name, 'type'))
						row.add('N/A')
						row.add('N/A')
						retVal.add(row)
					}
					else if(!blk.listAttMappings.isEmpty){
						retVal.addAll(writeAttNameListsPerBlock(blk))
					}
					else{
						retVal.addAll(writeListsPerBlock(blk))
					}
					retVal
				])»
			«ENDIF»
			«IF !blk.propRefs.isEmpty»
			\subsubsection{Properties}
			%
			«writeLatexTable(#['Name', 'Type', 'Optional'], #['l', 'l', 'c'], [
				val retVal = new ArrayList<List<String>>	
				for(propRef : sort(blk.propRefs, new Comparator<PropertyReference>(){
					
					override compare(PropertyReference o1, PropertyReference o2) {
						o1.propRef.name.compareTo(o2.propRef.name)
					}
					
				})){
					val row = new ArrayList<String>
					row.add(propRef.propRef.name)
					row.add(propRef.propRef.propType.writeTypeSpec)
					row.add(if(propRef.optional)'T'else 'F')
					retVal.add(row)
				}
				retVal
			])»
			«ENDIF»
			\newpage
		«ENDFOR»
	'''
	
	
	def writeAttNameListsPerBlock(BlockDefinition blkRef){
		val retVal = new ArrayList<List<String>>
		for(listMap: sort(blkRef.listAttMappings, new Comparator<AttNameListMap>(){
			
			override compare(AttNameListMap o1, AttNameListMap o2) {
				o1.attType.name.compareTo(o2.attType.name)
			}
			
		})){
			val row = new ArrayList<String> 
			row.add(hyperLink(listMap.attType.name, 'type'))
			row.add(listMap.attDefn.name)
			row.add('N/A')
			retVal.add(row)
		}
		retVal
	}

	def writeListsPerBlock(BlockDefinition blkRef){
		val retVal = new ArrayList<List<String>>
		for(listMap: sort(blkRef.listTypeMappings, new Comparator<AttValListMap>(){
			
			override compare(AttValListMap o1, AttValListMap o2) {
				o1.attType.name.compareTo(o2.attType.name)
			}
			
		})){
			val row = new ArrayList<String> 
			row.add(hyperLink(listMap.attType.name, 'type'))
			row.add(blkRef.keyAttName)
			row.add(listMap.attDefn.name)
			retVal.add(row)
		}
		retVal
	}

	def writeFunctions(Library it)'''
		\section{Function Definitions}
		
		«FOR func : sort(funcDefns, new Comparator<FunctionDefnBody>(){
			override compare(FunctionDefnBody o1, FunctionDefnBody o2) {
				o1.name.compareTo(o2.name)
			}
		})»
			\subsection{«func.name»}
			%
			«IF func.funcSpec.descn != null»
				«func.funcSpec.descn»
			«ENDIF»
			%
			\begin{description}
				\item[Returns] «func.funcSpec.returnType.writeTypeSpec.protectString»
			\end{description}
			
			\subsubsection{«IF func.funcSpec.argument instanceof NamedFuncArgs»Named «ENDIF»Arguments}
			%
			«writeLatexTable(#['Argument', 'Type', 'Description'], #['l','l','l'], [
				val retVal = new ArrayList<List<String>>
				for(att: sort(func.funcSpec.argument.arguments, new Comparator<FuncArgumentDefinition>(){
					override compare(FuncArgumentDefinition o1, FuncArgumentDefinition o2) {
						o1.name.compareTo(o2.name)
					}
				})){
					val row = new ArrayList<String>
					row.add(att.name)
					row.add(att.typeSpec.writeTypeSpec)
					row.add(att.descn)
					retVal.add(row)
				}
				retVal
			])»
			«IF func.funcSpec.argument instanceof NamedFuncArgs»
				\\
				\\
				\\
				«writeLatexTable(#['Signatures'], #['l'], [
					val retVal = new ArrayList<List<String>>
					val args = func.funcSpec.argument as NamedFuncArgs
					for(sig : args.sigLists){
							val row = new ArrayList<String>
							row.add('''«FOR att : sig.argRefs BEFORE '(' SEPARATOR ', ' AFTER ')'»«att.argRef.name»«IF att.optional»?«ENDIF»«ENDFOR»''')
							retVal.add(row)
					}
					retVal
				])»
			«ENDIF»
		«ENDFOR»
		
	'''

	def writeLists(Library it)'''
		\section{List Definitions}
		«FOR listDefn : sort(typeDefns, new Comparator<AbstractTypeDefinition>(){
			
			override compare(AbstractTypeDefinition o1, AbstractTypeDefinition o2) {
				o1.name.compareTo(o2.name)
			}
			
		})»
			«IF listDefn instanceof ListTypeDefinition»
					\subsection{«listDefn.name.protectString»}
					\label{type:«listDefn.name.protectRefString»}
					%
					Options:
					\begin{description}
						«IF listDefn.superRef != null»
							\item[extends] «hyperLink(listDefn.superRef.name.protectString, 'type')»
						«ENDIF»
						\item[anonymous] «if(listDefn.isAnonymous) "true" else "false"»
						\item[can define categories] «if(listDefn.isEnumList) "true" else "false"»
						«IF listDefn.catMapType != null»
							\item[supports category mapping with type] «listDefn.catMapType.writeTypeSpec.protectString»
							\item[category mapping optional] «if(listDefn.isCatMappingOptional) "true" else "false"»
						«ENDIF»
						«IF listDefn.altType != null»
							\item[alternate type] «listDefn.altType.writeTypeSpec»
						«ENDIF»
					\end{description}
				«IF !listDefn.isIsSuper»
					%
					«writeLatexTable(#['Attribute', 'Type', 'Description'], #['l','l','l'], [
						val retVal = new ArrayList<List<String>>
						for(att: sort(listDefn.attributes, new Comparator<ListAttributeDefn>(){
							override compare(ListAttributeDefn o1, ListAttributeDefn o2) {
								o1.name.compareTo(o2.name)
							}
						})){
							val row = new ArrayList<String>
							row.add(att.name)
							row.add(att.attType.writeTypeSpec)
							row.add('')
							retVal.add(row)
						}
						retVal
					])»
					\\
					\\
					\\
					«writeLatexTable(#['Signatures'], #['l'], [
						val retVal = new ArrayList<List<String>>
						for(sig : listDefn.sigLists){
								val row = new ArrayList<String>
								row.add('''«FOR att : sig.attRefs BEFORE '(' SEPARATOR ', ' AFTER ')'»«att.attRef.name»«IF att.optional»?«ENDIF»«ENDFOR»''')
								retVal.add(row)
						}
						retVal
					])»
				«ELSE»
					List Super Type
				«ENDIF»
			«ENDIF»
		«ENDFOR»
		\newpage
	'''
		
	def writeSubLists(Library it)'''
		\section{Sublist Definitions}
		«FOR listDefn : typeDefns»
			«IF listDefn instanceof SubListTypeDefinition»
				\subsection{«listDefn.name.protectString»}
				\label{type:«listDefn.name.protectRefString»}
				%
				«writeLatexTable(#['Attribute', 'Type', 'Description'], #['l','l','l'], [
					val retVal = new ArrayList<List<String>>
					for(att: sort(listDefn.attributes, new Comparator<ListAttributeDefn>(){
						
						override compare(ListAttributeDefn o1, ListAttributeDefn o2) {
							o1.name.compareTo(o2.name)
						}
						
					})){
						val row = new ArrayList<String>
						row.add(att.name)
						row.add(att.attType.writeTypeSpec)
						row.add('')
						retVal.add(row)
					}
					retVal
				])»
				\\
				\\
				\\
				«writeLatexTable(#['Signatures'], #['l'], [
					val retVal = new ArrayList<List<String>>
					for(sig : listDefn.sigLists){
						val row = new ArrayList<String>
						row.add('''«FOR att : sig.attRefs BEFORE '(' SEPARATOR ', ' AFTER ')'»«att.attRef.name»«IF att.optional»?«ENDIF»«ENDFOR»''')
						retVal.add(row)
					}
					retVal
				])»
			«ENDIF»
		«ENDFOR»
		\newpage
	'''

	def writeTypes(Library it)'''
		\section{Type Definitions}
		
		\subsection{Standard}
		%
		«writeLatexTable(#['Name', 'Type Class'], #['l', 'l'], [
			val retVal = new ArrayList<List<String>>
			for(td: sort(typeDefns, new Comparator<AbstractTypeDefinition>(){
				
				override compare(AbstractTypeDefinition o1, AbstractTypeDefinition o2) {
					o1.name.compareTo(o2.name)
				}
				
			})){
				if(td instanceof TypeDefinition){
					if(td.typeClass != TypeClass.ENUM){
						val row = new ArrayList<String>
						row.add(td.name + '\\label{type:' + td.name + '}')
						row.add(td.typeClass.toString)
						retVal.add(row)
					}
				}
			}
			retVal
		])»

		\subsection{Mapping Types}
		%
		«writeLatexTable(#['Name', 'Data Type', 'Variable Type'], #['l', 'l', 'l'], [
			val retVal = new ArrayList<List<String>>
			for(td: sort(typeDefns, new Comparator<AbstractTypeDefinition>(){
				
				override compare(AbstractTypeDefinition o1, AbstractTypeDefinition o2) {
					o1.name.compareTo(o2.name)
				}
				
			})){
				if(td instanceof MappingTypeDefinition){
					val row = new ArrayList<String>
					row.add(td.name + '\\label{type:' + td.name + '}')
					row.add(td.colType.writeTypeSpec)
					row.add(td.asType.writeTypeSpec)
					retVal.add(row)
				}
			}
			retVal
		])»

		\subsection{Enumeration Types}
		%
		«writeLatexTable(#['Name', 'Enumerations'], #['l', 'p{8cm}'], [
			val retVal = new ArrayList<List<String>>
			for(td: sort(typeDefns, new Comparator<AbstractTypeDefinition>(){
				
				override compare(AbstractTypeDefinition o1, AbstractTypeDefinition o2) {
					o1.name.compareTo(o2.name)
				}
				
			})){
				if(td instanceof TypeDefinition){
					if(td.typeClass == TypeClass.ENUM){
						val row = new ArrayList<String>
						row.add(td.name + '\\label{type:' + td.name + '}')
						row.add('''«FOR ev : td.enumArgs SEPARATOR ', '»«ev.name»«ENDFOR»''')
						retVal.add(row)
					}
				}
			}
			retVal
		])»

	'''

	def String writeTypeSpec(TypeSpec it)'''
		«hyperLink(typeName.name, 'type')»«IF elementType != null»[«elementType.writeTypeSpec»]«ENDIF»«IF cellType != null»[[«cellType.writeTypeSpec»]]«ENDIF»«FOR a : argSpecs BEFORE '(' SEPARATOR ',' AFTER ')'»«a.writeTypeSpec»«ENDFOR»«IF rtnSpec != null»«rtnSpec.writeTypeSpec ?: ''»«ENDIF»
	'''
	

	def private String printRange(int val1, int val2)'''
		(«val1», «if(val2 == 0) "$\\infty$" else val2»)
	'''

	def static protectString(String name){
		name?.replace("_", "\\_")
	}

	def static protectRefString(String name){
		name?.replace("_", "Dash")
	}

	def private writeLatexTable(List<String> header, List<String> columnFormat, () => List<List<String>> columnLambda)
		'''
		\begin{tabular}{«FOR c : columnFormat» «c» «ENDFOR»}
		«FOR h : header SEPARATOR ' & ' AFTER '\\\\\\hline'»«h»«ENDFOR»
		«FOR row : columnLambda.apply»
			«FOR colVal : row SEPARATOR ' & ' AFTER '\\\\'»«colVal.protectString»«ENDFOR»
		«ENDFOR»
		\end{tabular}
		'''

}


